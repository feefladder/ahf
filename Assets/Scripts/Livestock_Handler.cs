using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Livestock_Handler : MonoBehaviour
{
    public int number_of_chickens, number_of_cows, number_of_goats;

    public double newcow, newgoat, newchicken;
    public Chicken chicken;
    public Goat goat;
    public Cow cow;
    public Decision_Handler handler;
    public Text cownum, chickennum, goatnum,
    cowcount, chickencount, goatcount;

    void Update()
    {
        chickennum.text = chickencount.text;
        goatnum.text = goatcount.text;
        cownum.text = cowcount.text;
    }

    public void Add_livestock(Livestock type)
    {

        if (type.type == "Cow")
        {
            if (number_of_cows == type.max)
            {
                return;
            }
        }
        if (type.type == "Chicken")
        {

            if (number_of_chickens == type.max)
            {

                return;
            }
        }
        if (type.type == "Goat")
        {
            if (number_of_goats == type.max)
            {
                return;
            }
        }

        if (handler.money >= type.cost)
        {
            handler.money -= type.cost;


        }
        else
        {
            handler.Nomoney.SetActive(true);
            return;
        }
        if (handler.labor >= type.required_labor)
        {
            handler.labor -= type.required_labor;

        }
        else
        {
            handler.Nolabour.SetActive(true);
            return;
        }

        if (type.type == "Cow")
        {
            number_of_cows += 1;
            cowcount.text = number_of_cows.ToString();
            newcow += 1;

        }

        if (type.type == "Goat")
        {
            number_of_goats += 1;
            goatcount.text = number_of_goats.ToString();
            newgoat += 1;

        }
        if (type.type == "Chicken")
        {
            number_of_chickens += 1;
            newchicken += 1;
            chickencount.text = number_of_chickens.ToString();


        }
    }

    public void Remove_livestock(Livestock type)
    {
        if (type.type == "Cow" & number_of_cows >= 1)
        {
            number_of_cows -= 1;
            if (newcow == 0)
            {
                handler.money += type.cost - (type.cost * (10d / 100d));
            }
            else { newcow -= 1; handler.money += type.cost; }
            handler.labor += type.required_labor;
            //total_expenses -= type.cost;
            cowcount.text = number_of_cows.ToString();
        }

        if (type.type == "Goat" & number_of_goats >= 1)
        {
            number_of_goats -= 1;
            if (newgoat == 0)
            {
                handler.money += type.cost - (type.cost * (10d / 100d));
            }
            else { newgoat -= 1; handler.money += type.cost; }
            handler.labor += type.required_labor;
            // total_expenses -= type.cost;
            goatcount.text = number_of_goats.ToString();
        }
        if (type.type == "Chicken" & number_of_chickens >= 1)
        {
            number_of_chickens -= 1;
            if (newchicken == 0)
            {
                handler.money += type.cost - (type.cost * (10d / 100d));
            }
            else { newchicken -= 1; handler.money += type.cost; }
            handler.labor += type.required_labor;
            //total_expenses -= type.cost;
            chickencount.text = number_of_chickens.ToString();
        }
    }

    public double LivestockExpense()
    {
        double expense = 0;

        expense += (chicken.cost * newchicken) + (goat.cost * newgoat) + (cow.cost * newcow);
        expense += (chicken.maintenance_cost * number_of_chickens) + (goat.maintenance_cost * number_of_goats) + (cow.maintenance_cost * number_of_cows);
        return expense;
    }
    public int LivestockIncome()
    {
        int income = 0;
        income += (chicken.product_revenue * number_of_chickens) + (goat.product_revenue * number_of_goats) + (cow.product_revenue * number_of_cows);
        return income;
    }

    public void NewGame()
    {
        number_of_chickens = 0;
        number_of_cows = 0;
        number_of_goats = 0;
}
}
