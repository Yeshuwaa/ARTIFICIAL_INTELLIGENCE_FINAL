using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Threading.Tasks;
public class PatrolState : StateMachineBehaviour
{
    EnemyController enemyController;
    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        enemyController = animator.GetComponentInParent<EnemyController>();
        enemyController.MoveToRandomWaypoint();
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        enemyController.agent.stoppingDistance = 1;
        #region Patrol Random WayPoints
        if (!enemyController.agent.pathPending)
        {
            //returns the distance of agent, if it is the same of stoping distance
            if (enemyController.agent.remainingDistance <= enemyController.agent.stoppingDistance)
            {
                //if agent has no path or agent is standing still
                if (!enemyController.agent.hasPath || enemyController.agent.velocity.sqrMagnitude == 0f)
                {
                    // Done
                    enemyController.MoveToRandomWaypoint();

                }
            }
        }
        #endregion
        #region Chase the player if detected
        if (enemyController.distanceToPlayer<enemyController.radius)
        {
            animator.SetBool("isPatroling", false);
            animator.SetBool("isChasing", true);
        }
        #endregion
    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    //override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    
    //}

    // OnStateMove is called right after Animator.OnAnimatorMove()
    //override public void OnStateMove(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that processes and affects root motion
    //}

    // OnStateIK is called right after Animator.OnAnimatorIK()
    //override public void OnStateIK(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    //{
    //    // Implement code that sets up animation IK (inverse kinematics)
    //}
}
