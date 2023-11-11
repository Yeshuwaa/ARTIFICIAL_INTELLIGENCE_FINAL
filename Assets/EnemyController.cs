using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEditor;
using UnityEngine;
using UnityEngine.AI;

public class EnemyController : MonoBehaviour
{
    [Header("State")]
    public string currentState;
    [Header("References")]
    public Animator animator;
    public NavMeshAgent agent;
    [Header("WayPoint")]
    public Transform Waypoints;
    public List<Transform> targetWaypoint;
    public int wayPointNumber;
    public bool isMoving;
    [Header("AI_References")]
    public float distanceToPlayer;
    public float returnToPatrolDistance;
    public Transform playerPosition;
    public float radius;
    public float chaseDuration;
    [Header("BaseValues")]
    public Transform playerPositionStored;
    public float chaseDurationStored;
    public float storedRadius;
    [Header("Particle Effects")]
    public GameObject slash;

    // Start is called before the first frame update
    void Start()
    {
        playerPositionStored = playerPosition;
        chaseDurationStored = chaseDuration;
        storedRadius = radius;
        agent = GetComponent<NavMeshAgent>();
        foreach (Transform tr in Waypoints.GetComponentsInChildren<Transform>())
        {
            targetWaypoint.Add(tr.gameObject.transform);
        }
        //MoveToRandomWaypoint();
    }

    // Update is called once per frame
    void Update()
    {
        distanceToPlayer = Vector3.Distance(agent.transform.position, playerPosition.transform.position);
        if (animator != null)
        {
            AnimationClip currentClip = GetCurrentAnimatorClip(animator, 0);
            
            // Store the animation name as a string
            if (currentClip != null)
            {
                currentState = currentClip.name;
            }
            else
            {
                currentState = "No animation playing";
            }
        }
        else
        {
            currentState = "Animator reference not set";
        }
        if (currentState == "AttackState")
        {
            Vector3 directionToPlayer = playerPosition.position - agent.transform.position;

            // Calculate the rotation that looks in the direction of the player.
            Quaternion lookRotation = Quaternion.LookRotation(directionToPlayer);

            // Apply the rotation to this GameObject, but only in the Y-axis to face the player.
            transform.rotation = Quaternion.Euler(0, lookRotation.eulerAngles.y, 0);
        }
    }
    public void MoveToRandomWaypoint()
    {
        if (targetWaypoint.Count == 0)
        {
            Debug.LogWarning("No waypoints available.");
            return;
        }

        int newWaypointIndex = GetRandomWaypointIndex();

        //4 != 4
        if (newWaypointIndex != wayPointNumber)
        {
            //we make this equal to random way point
            wayPointNumber = newWaypointIndex;
            //Setting the agent new destination
            agent.SetDestination(targetWaypoint[wayPointNumber].position);
        }
        else
        {
            // If the random waypoint is the same as the current one, find another waypoint
            MoveToRandomWaypoint();
        }
    }
    //CONCATINATION
    private int GetRandomWaypointIndex()
    {
        //0 - 4
        return Random.Range(0, targetWaypoint.Count);
    }
    private AnimationClip GetCurrentAnimatorClip(Animator anim, int layer)
    {
        AnimatorStateInfo stateInfo = anim.GetCurrentAnimatorStateInfo(layer);
        return anim.GetCurrentAnimatorClipInfo(layer)[0].clip;
    }

    public void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, radius);
    }

   
}
