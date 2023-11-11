using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public enum AI_Types
{
    Archer,
    Warrior,
    Mage,
    Ninja
}
public class NewAiBehaviour : MonoBehaviour
{
    Dictionary<AI_Types, int> aiModelIndices = new Dictionary<AI_Types, int>()
    {
        { AI_Types.Archer, 0 },
        { AI_Types.Warrior, 1 },
        { AI_Types.Mage, 2 },
        { AI_Types.Ninja, 3 }
    };

    [Header("State")]
    public string currentState;
    public AI_Types aiTypes;

    [Header("Targets")]
    public Transform[] targets;
    [SerializeField] private string targetTag = "Team1";

    [Header("References")]
    public List<GameObject> aiModel;
    public Animator animator;
    public NavMeshAgent agent;

    [Header("Attack Range")]
    public float range;

    [Header("Enemy Values")]
    public float health;
    public float damage;
    public new string tag = "Team1";

    [Header("VFX")]
    public GameObject Arrow;
    public Transform spawnArcherFX;

    private bool isDead = false;
    // Start is called before the first frame update
    void Start()
    {
        agent = GetComponent<NavMeshAgent>();
        Action<AI_Types> activateAiModel = (AI_Types aiType) => 
        {
            aiModel[aiModelIndices[aiType]].SetActive(true);
            animator = aiModel[aiModelIndices[aiType]].GetComponent<Animator>();
        };
        activateAiModel(aiTypes);

        switch (aiTypes)
        {
            case AI_Types.Archer:
                health = GameManager.Instance.archerHealth;
                range = GameManager.Instance.archerRange;
                damage = GameManager.Instance.archerDamage;
                break;
            case AI_Types.Warrior:
                health = GameManager.Instance.warriorHealth;
                range = GameManager.Instance.warriorRange;
                damage = GameManager.Instance.warriorDamage;
                break;
            case AI_Types.Mage:
                health = GameManager.Instance.mageHealth;
                range = GameManager.Instance.mageRange;
                damage = GameManager.Instance.mageDamage;
                break;
            case AI_Types.Ninja:
                health = GameManager.Instance.ninjaHealth;
                range = GameManager.Instance.ninjaRange;
                damage = GameManager.Instance.ninjaDamage;
                break;
            default:
                break;
        }

        AssignTargetsByTag();
    }

    private void Update()
    {
             
    }
    // Update is called once per frame
    void LateUpdate()
    {
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
    }
    private AnimationClip GetCurrentAnimatorClip(Animator anim, int layer)
    {
        AnimatorStateInfo stateInfo = anim.GetCurrentAnimatorStateInfo(layer);
        return anim.GetCurrentAnimatorClipInfo(layer)[0].clip;
    }

    void OnTriggerEnter(Collider other)
    {   
        if (other.CompareTag("Arrow"))
        {
            Debug.Log("Arrow Hit!");
            TakeDamage(GameManager.Instance.archerDamage);
            Destroy(other.gameObject);
        }
    }

    public void TakeDamage(float damageAmount)
    {
        health -= damageAmount;
        Debug.Log("Got Hit!");

        if (health <= 0 && !isDead)
        {
            isDead = true;
            animator.SetBool("isDead", true);
            animator.SetBool("isAttacking", false);
            StartCoroutine(OnDeadAnimationComplete());
        }
    }

    IEnumerator OnDeadAnimationComplete()
    {
        yield return new WaitForSeconds(1.11f);

        if (animator != null)
        {
            animator.enabled = false;
        }

        if (agent != null)
        {
            agent.enabled = false;
        }
        yield return null;
    }

    void AssignTargetsByTag()
    {
        GameObject[] targetObjects = GameObject.FindGameObjectsWithTag(targetTag);

        if (targetObjects.Length > 0)
        {
            targets = new Transform[targetObjects.Length];

            for (int i = 0; i < targetObjects.Length; i++)
            {
                targets[i] = targetObjects[i].transform;
            }
        }
        else
        {
            Debug.LogWarning("No GameObjects found with the specified tag: " + targetTag);
            // Optionally, set targets to an empty array or null if you want to handle it differently
            targets = new Transform[0]; // or targets = null;
        }
    }
}