using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;

public class Tab : MonoBehaviour {
    public UnityEvent onTabDisable;
    public UnityEvent onTabEnable;
    //we also want the button to update if we close ourselves
    void OnDisable() {
        onTabDisable.Invoke();
    }

    void OnEnable() {
        onTabEnable.Invoke();
    }
}