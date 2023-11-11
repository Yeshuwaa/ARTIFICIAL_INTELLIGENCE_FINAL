using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ArcherAttackState : StateMachineBehaviour
{
    NewAiBehaviour aiBehaviour;
    // OnStateEnter is called when a transition starts and the state machine starts to evaluate this state
    override public void OnStateEnter(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        aiBehaviour = animator.GetComponentInParent<NewAiBehaviour>();
    }

    // OnStateUpdate is called on each Update frame between OnStateEnter and OnStateExit callbacks
    override public void OnStateUpdate(Animator animator, AnimatorStateInfo stateInfo, int layerIndex)
    {
        GameObject nearestGameObject = GameObject.FindWithTag(aiBehaviour.tag);
        if (nearestGameObject != null)
        {
            // Check if the GameObject is within the radius
            float distance = Vector3.Distance(aiBehaviour.agent.transform.position, nearestGameObject.transform.position);
            if (distance >= aiBehaviour.range)
            {
                animator.SetBool("isWalking", true);
                animator.SetBool("isAttacking", false);
                aiBehaviour.agent.speed = 3.5f;
            }
        }
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
