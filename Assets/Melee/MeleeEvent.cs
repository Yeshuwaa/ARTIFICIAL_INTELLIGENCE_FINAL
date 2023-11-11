using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeleeEvent : MonoBehaviour
{
    NewAiBehaviour newAiBehaviour;

    // Start is called before the first frame update
    void Start()
    {
        newAiBehaviour = GetComponentInParent<NewAiBehaviour>();
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void SlashDamage()
    {
        // Check if the NewAiBehaviour and targets array exist
        if (newAiBehaviour != null && newAiBehaviour.targets != null)
        {
            // Loop through all targets
            for (int i = 0; i < newAiBehaviour.targets.Length; i++)
            {
                // Check if the target is within attack range
                float distanceToTarget = Vector3.Distance(transform.position, newAiBehaviour.targets[i].position);
                if (distanceToTarget <= newAiBehaviour.range)
                {
                    // Apply damage to the current target
                    newAiBehaviour.targets[i].GetComponent<NewAiBehaviour>().TakeDamage(newAiBehaviour.damage);
                }
            }
        }
    }
}