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
        // Check if the NewAiBehaviour and target exist
        if (newAiBehaviour != null && newAiBehaviour.target != null)
        {
            // Check if the target is within attack range
            float distanceToTarget = Vector3.Distance(transform.position, newAiBehaviour.target.position);
            if (distanceToTarget <= newAiBehaviour.range)
            {
                newAiBehaviour.target.GetComponent<NewAiBehaviour>().TakeDamage(newAiBehaviour.damage);
            }
        }
    }
}
