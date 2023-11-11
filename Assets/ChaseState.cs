using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChaseState : StateMachineBehaviour
{
    EnemyController enemyController;
    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        enemyController = animator.GetComponentInParent<EnemyController>();
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        #region return to patrol after chasing for a certain amount
        enemyController.agent.SetDestination(enemyController.playerPosition.transform.position);
        enemyController.chaseDuration -= Time.deltaTime;
        if (enemyController.chaseDuration<=0)
        {
            enemyController.playerPosition = null;
            animator.SetBool("isChasing", false);
            animator.SetBool("isPatroling", true);
        }
        #endregion
        #region Attack Player if it is within its range
        if (enemyController.distanceToPlayer<= 2f)
        {
            enemyController.agent.stoppingDistance = 2;
            animator.SetBool("isChasing", false);
            animator.SetBool("isAttacking", true);
        }
        #endregion

    }

    // OnStateExit is called when a transition ends and the state machine finishes evaluating this state
    override public void OnStateExit(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        enemyController.playerPosition = enemyController.playerPositionStored;
        enemyController.chaseDuration = enemyController.chaseDurationStored;
    }

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
