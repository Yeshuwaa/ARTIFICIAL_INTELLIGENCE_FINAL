using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MageEvent : MonoBehaviour
{
    NewAiBehaviour newAiBehaviour;
    public float speed;
    // Start is called before the first frame update
    void Start()
    {
        newAiBehaviour = GetComponentInParent<NewAiBehaviour>();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
    public void ShootSpell()
    {
        GameObject spellFX = Instantiate(newAiBehaviour.Spell, newAiBehaviour.spawnMageFX.position, newAiBehaviour.spawnMageFX.rotation);
        Rigidbody bulletRigidbody = spellFX.GetComponent<Rigidbody>();
        bulletRigidbody.AddForce(transform.forward * speed, ForceMode.Impulse);
    }
}
