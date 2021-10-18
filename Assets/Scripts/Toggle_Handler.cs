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
        //toggle.interactable = !(money > _Handler.money);
    }
    public void TogglesValueChanged(int amount, int labor, Toggle toggle)
    {
        if (toggle.isOn)
        {
            if (amount < _Handler.money)
            {
                _Handler.money -= amount;
            }
            else
            {
                _Handler.Nomoney.SetActive(true);
            }
            if (labor < _Handler.labor)
            {
                _Handler.labor -= labor;
            }
            else
            {
                _Handler.Nolabour.SetActive(true);

            }
        }
        else
        {
            _Handler.money += amount;
            _Handler.labor += labor;
        }
    }
}
