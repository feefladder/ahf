using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Toggle_Handler : MonoBehaviour
{
    public int money;
    public int labor;
    private Toggle toggle;
    public Decision_Handler _Handler;
    void Start()
    {
        toggle = gameObject.GetComponent<Toggle>() as Toggle;
        toggle.onValueChanged.AddListener(delegate { TogglesValueChanged(money, labor, toggle); });

    }
    void Update()
    {
        toggle.interactable = !(money > _Handler.money);
    }
    public void TogglesValueChanged(int amount, int labor, Toggle toggle)
    {
        if (toggle.isOn)
        {
            _Handler.money -= amount;
            _Handler.labor -= labor;

        }
        else
        {
            _Handler.money += amount;
            _Handler.labor += labor;
        }
    }
}
