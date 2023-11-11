using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public class PointAtoB : MonoBehaviour
{
    public Transform targetDestination; // The destination point (Point B)
    private NavMeshAgent agent;

    private void Start()
    {
        agent = GetComponent<NavMeshAgent>();

        // Check if the NavMeshAgent and the targetDestination are set
        if (agent == null || targetDestination == null)
        {
            Debug.LogError("NavMeshAgent or target destination not set.");
            enabled = false; // Disable the script
            return;
        }

        // Set the initial destination
        SetDestination(targetDestination.position);
    }

    private void SetDestination(Vector3 destination)
    {
        agent.SetDestination(destination);
    }

    private void Update()
    {
        // Check if the agent has reached the destination
        if (!agent.pathPending && agent.remainingDistance < 0.1f)
        {
            // Destination reached, do something (e.g., stop, play an animation, etc.)
            Debug.Log("Destination reached!");
        }
    }
}
