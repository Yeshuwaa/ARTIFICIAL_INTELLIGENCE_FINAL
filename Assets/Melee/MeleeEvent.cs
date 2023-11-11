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
                // Check if the target object is not null and not destroyed
                if (newAiBehaviour.targets[i] != null && newAiBehaviour.targets[i].gameObject != null)
                {
                    // Check if the target's Transform is not null
                    Transform targetTransform = newAiBehaviour.targets[i];
                    if (targetTransform != null)
                    {
                        // Check if the target is within attack range
                        float distanceToTarget = Vector3.Distance(transform.position, targetTransform.position);
                        if (distanceToTarget <= newAiBehaviour.range)
                        {
                            // Get the NewAiBehaviour component of the current target
                            NewAiBehaviour targetAiBehaviour = targetTransform.GetComponent<NewAiBehaviour>();

                            // Check if the target has a NewAiBehaviour component and is not destroyed
                            if (targetAiBehaviour != null && targetAiBehaviour.gameObject != null)
                            {
                                // Apply damage to the current target
                                targetAiBehaviour.TakeDamage(newAiBehaviour.damage);
                            }
                        }
                    }
                }
            }
        }
    }
}