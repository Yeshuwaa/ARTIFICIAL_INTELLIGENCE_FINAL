using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class AnimationEvent : MonoBehaviour
{
    public EnemyController enemyController;

    private void Start()
    {
        enemyController = GetComponentInParent<EnemyController>();
    }
    public void SpawnSlash()
    {
        GameObject newParticle = Instantiate(enemyController.slash, enemyController.agent.transform.position, enemyController.agent.transform.rotation);
    }
}
