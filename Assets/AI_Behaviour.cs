using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.AI;

[RequireComponent(typeof(NavMeshAgent))]
public class AI_Behaviour : MonoBehaviour
{
    private NavMeshAgent agent;
    public Transform Waypoints;
    public List<Transform> targetPos;
    public int wayPointNumber;
    public bool isMoving;


    public Transform player; // Reference to the player's transform
    public float playerFollowRange = 5f; // Range at which the agent follows the player

    // Start is called before the first frame update
    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        foreach (Transform tr in Waypoints.GetComponentsInChildren<Transform>())
        {
            targetPos.Add(tr.gameObject.transform);
        }
        MoveToRandomWaypoint();
    }

    // Update is called once per frame
    void Update()
    {
            //returns true or false, if AI has next destination.
            if (!agent.pathPending)
            {
                //returns the distance of agent, if it is the same of stoping distance
                if (agent.remainingDistance <= agent.stoppingDistance)
                {
                    //if agent has no path or agent is standing still
                    if (!agent.hasPath || agent.velocity.sqrMagnitude == 0f)
                    {
                        // Done
                        Debug.Log("DestinationReached");
                        MoveToRandomWaypoint();
                    }


                }
            }
        if (gameObject.layer == LayerMask.NameToLayer("Walls_1"))
        {
            // Check if the NavMeshAgent component exists
            if (agent != null)
            {
                // Set the rotation to zero along the X-axis
                transform.rotation = Quaternion.Euler(0f, transform.rotation.eulerAngles.y, transform.rotation.eulerAngles.z);
            }
            else
            {
                Debug.LogWarning("NavMeshAgent component not found on the GameObject.");
            }
        }
    }

    private  void MoveToRandomWaypoint()
    {

        //code if we forgot to add waypoints into the list
        if (targetPos.Count == 0)
        {
            Debug.LogWarning("No waypoints available.");
            return;
        }

        //Make the bool moving true, get a random waypoint number
        isMoving = true;
        int newWaypointIndex = GetRandomWaypointIndex();
        //if waypoint number is not the same as waypoint index, then proceed to destination
        if (newWaypointIndex != wayPointNumber)
        {
            //we make this equal to random way point
            wayPointNumber = newWaypointIndex;
            //Setting the agent new destination
            agent.SetDestination(targetPos[wayPointNumber].position);
        }
        else
        {
            // If the random waypoint is the same as the current one, find another waypoint
            MoveToRandomWaypoint();
        }
    }

    private int GetRandomWaypointIndex()
    {
        return Random.Range(0, targetPos.Count);
    }

    private void OnDrawGizmos()
    {
        Gizmos.color = Color.red;
        Gizmos.DrawWireSphere(transform.position,playerFollowRange);
    }
}
