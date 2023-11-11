using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;
// enums for our states
public enum e_AI_State
{
    FollowPlayer,
    Patrol

}
//Required Navmesh agent component

[RequireComponent(typeof(NavMeshAgent))]
public class AI_Follow_Patrol : MonoBehaviour
{
    public e_AI_State aiState;
    public Transform playerPosition;
    private NavMeshAgent agent;
    public Transform Waypoints;
    public List<Transform> targetWaypoint;
    public int wayPointNumber;
    public bool isMoving;

    public float playerFollowRange;

    public float followDuration;

    // Start is called before the first frame update
    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        foreach (Transform tr in Waypoints.GetComponentsInChildren<Transform>())
        {
            targetWaypoint.Add(tr.gameObject.transform);
        }
        MoveToRandomWaypoint();
    }

    // Update is called once per frame
    void Update()
    {
        float distanceToPlayer = Vector3.Distance(transform.position, playerPosition.position);
       

        if (distanceToPlayer<= playerFollowRange)
        {
            aiState = e_AI_State.FollowPlayer;
        }
        if (followDuration <= 0)
        {
            aiState = e_AI_State.Patrol;
        }
        else
        {
            aiState = e_AI_State.Patrol;
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

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position, playerFollowRange);
    }
}
