using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Activate_VFX : MonoBehaviour
{

    public GameObject VFX;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.GetKeyDown(KeyCode.Space))
        {
            VFX.SetActive(true);
        }

        if (Input.GetKeyDown(KeyCode.AltGr))
        {
            VFX.SetActive(false);
        }



    }
}
