using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.AI;

public enum OffMeshLinkMoveMethod
{
    Teleport,
    NormalSpeed,
    Parabola,
    Curve,
    Climb
}
public class AI_Agent : MonoBehaviour
{
    public NavMeshAgent agent;

    public OffMeshLinkMoveMethod method;
    public AnimationCurve curve = new AnimationCurve();
    IEnumerator Start()
    {
        
        NavMeshAgent agent = GetComponent<NavMeshAgent>();
        agent.autoTraverseOffMeshLink = false;
        while (true)
        {
            if (agent.isOnOffMeshLink)
            {
                if (method == OffMeshLinkMoveMethod.NormalSpeed)
                    yield return StartCoroutine(NormalSpeed(agent));
                if (method == OffMeshLinkMoveMethod.Climb)
                    yield return StartCoroutine(Climb(agent));
                else if (method == OffMeshLinkMoveMethod.Parabola)
                    yield return StartCoroutine(Parabola(agent, 2.0f, 0.5f));
                else if (method == OffMeshLinkMoveMethod.Curve)
                    yield return StartCoroutine(Curve(agent, 0.5f));
                agent.CompleteOffMeshLink();
            }
            yield return null;
        }
    }
    IEnumerator NormalSpeed(NavMeshAgent agent)
    {
        OffMeshLinkData data = agent.currentOffMeshLinkData;
        Vector3 endPos = data.endPos + Vector3.up * agent.baseOffset;
        while (agent.transform.position != endPos)
        {
            agent.transform.position = Vector3.MoveTowards(agent.transform.position, endPos, agent.speed * Time.deltaTime);
            yield return null;
        }
    } 
    IEnumerator Climb(NavMeshAgent agent)
    {
        OffMeshLinkData data = agent.currentOffMeshLinkData;
        Vector3 endPos = data.endPos + Vector3.up * agent.baseOffset;
        Vector3 targetDir = endPos - agent.transform.position;
        float angle = Mathf.Atan2(targetDir.y, targetDir.z) * Mathf.Rad2Deg;
        while (agent.transform.position != endPos)
        {
            agent.transform.SetPositionAndRotation(Vector3.MoveTowards(agent.transform.position, endPos, agent.speed * Time.deltaTime), Quaternion.Euler(0, angle, 0));
            yield return null;
        }
    }
    IEnumerator Parabola(NavMeshAgent agent, float height, float duration)
    {
        OffMeshLinkData data = agent.currentOffMeshLinkData;
        Vector3 startPos = agent.transform.position;
        Vector3 endPos = data.endPos + Vector3.up * agent.baseOffset;
        float normalizedTime = 0.0f;
        while (normalizedTime < 1.0f)
        {
            float yOffset = height * 4.0f * (normalizedTime - normalizedTime * normalizedTime);
            agent.transform.position = Vector3.Lerp(startPos, endPos, normalizedTime) + yOffset * Vector3.up;
            normalizedTime += Time.deltaTime / duration;
            yield return null;
        }
    }
    IEnumerator Curve(NavMeshAgent agent, float duration)
    {
        OffMeshLinkData data = agent.currentOffMeshLinkData;
        Vector3 startPos = agent.transform.position;
        Vector3 endPos = data.endPos + Vector3.up * agent.baseOffset;
        float normalizedTime = 0.0f;
        while (normalizedTime < 1.0f)
        {
            float yOffset = curve.Evaluate(normalizedTime);
            agent.transform.position = Vector3.Lerp(startPos, endPos, normalizedTime) + yOffset * Vector3.up;
            normalizedTime += Time.deltaTime / duration;
            yield return null;
        }
    }
    
    // Start is called before the first frame update
  

    // Update is called once per frame
    void Update()
    {
        
    }
}
