using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class PlayerStatsItem : MonoBehaviour
{
    public Text Title;
    public Text Amount;
    public string statName;

    public void SetAmount(double newAmount) {
        Amount.text = newAmount.ToString();
    }
}
