using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    [Header("Health")]
    public float archerHealth;
    public float ninjaHealth;
    public float warriorHealth;
    public float mageHealth;
    [Header("Damage")]
    public float archerDamage;
    public float ninjaDamage;
    public float warriorDamage;
    public float mageDamage;

    [Header("Range")]
    public float archerRange;
    public float ninjaRange;
    public float warriorRange;
    public float mageRange;
    

    private void Awake()
    {
        // If there is an instance, and it's not me, delete myself.

        if (Instance != null && Instance != this)
        {
            Destroy(this);
        }
        else
        {
            Instance = this;
        }
    }

}
