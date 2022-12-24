using UnityEngine;

public class AssetManager : MonoBehaviour {
    public double money, labour;
    public int labourers;
    public DoubleEvent onMoneyChanged, OnLabourChanged;
    public PopupInsufficient noMoney;
    public PopupInsufficient noLabour;

    public bool DecreaseAssets(double decMoney=0, double decLabour=0){
        // Decrease the assets with given amounts. returns 0 if successful, in
        // line with successful-program-completion conventions
        // otherwise shows dialogs
        if(money >= decMoney && labour >= decLabour){
            money -= decMoney;
            labour -= decLabour;
            if (decMoney != 0)
                onMoneyChanged.Invoke(money);
            if (decLabour != 0)
                OnLabourChanged.Invoke(labour);
            return false;
        } else {
            if(money < decMoney){
                noMoney.NotEnough((int)decMoney - (int)money);
                noMoney.gameObject.SetActive(true);
            };
            if(labour < decLabour){
                noLabour.NotEnough((int)decLabour - (int)labour);
                noLabour.gameObject.SetActive(true);
            }
            return true;
        }
    }
    public void IncreaseAssets(double incMoney = 0, double inclabour=0){
        money += incMoney;
        labour += inclabour;
    }
}