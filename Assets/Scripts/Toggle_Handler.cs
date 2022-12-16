using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Toggle_Handler : MonoBehaviour
{
    public int money;
    public int labor;
    private Toggle toggle;
    public bool AutoInteractable;
    public Decision_Handler _Handler;
    void Start()
    {
        toggle = gameObject.GetComponent<Toggle>() as Toggle;
        toggle.onValueChanged.AddListener(delegate { TogglesValueChanged(money, labor, toggle); });

    }
    void Update()
    {
        
    }
    public void TogglesValueChanged(int amount, int labor, Toggle toggle)
    {
        if (toggle.isOn)
        {
            if(!_Handler.DecreaseAssets(decMoney: amount,decLabor: labor)){
                // processing that needs to be done if successful
            } else {
                // processing for unsuccessful. -> set toggle back to false
                toggle.SetIsOnWithoutNotify(false);
            }
        }
        else
        {
            _Handler.IncreaseAssets(amount, labor);
        }
    }
}
