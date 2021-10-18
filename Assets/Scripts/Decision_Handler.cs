using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Decision_Handler : MonoBehaviour
{
    #region variables
    //static public Decision_Handler instance { get { return s_Instance; } }
    public Decision_Handler s_Instance;
    [Header("Farm parameters")]
    #region 
    public List<Crops> crops = new List<Crops>(10);
    public double money = 100000d;
    public double fertility=60d;
    public int salinity;
    public int labor=250;
    //public Toggle manureapplied;
    public Toggle isterracebuilt; 
    public bool isterracemaintained;
    public Toggle isgrassstripplaced;
    public Toggle applymanure;
    public Toggle isdripirrigation;
    public Toggle isgreenhousebuilt;
    public Toggle washfield;
    public int years = 1;
    public int labor_cost = 1500;
    public Toggle hire_labor;
    public int off_farm_job = 2000;
    public int labourers;
    public Toggle isofffarmjob;
    public int number_of_chickens,number_of_cows,number_of_goats;
    
    public double newcow,newgoat,newchicken;
    public Chicken chicken;
    public Goat goat;
    public Cow cow;
    public double startamount;
    #endregion

    [Header("Family parameters")]
    #region
    public Children eldest = new Children(18,1,true,true,false);
    public Children second = new Children(12, 2, true, false, false);
    public Toggle health_insurance;
    public Toggle birth_control;
    public int HI_cost = 1500;
    public int HI_inperchild = 500;
    public int basic_expenses = 5000;
    public int increment_per_child = 750;
    public int school_fees = 1000;
    public int birth_control_cost = 300;
    public List<Children> kids = new List<Children>();
    public int sec_kids;
    public int uni_kids;
    int seckidsavailable=0;
    int unikidsavailable = 0;
    public Text seckidstext;
    public Text unikidstext;
    public Text secavai;
    public Text uniavai;
    public Toggle buy_house;
    public Toggle buy_car;
    public int house_cost = 15000;
    public int car_cost = 10000;
    #endregion
    [Header("UI")]
    #region
    public GameObject grass_strips, terraces;
    public GameObject Nomoney,Nolabour;
    public Text Money, Fertility, Salinity, Labor, Year, cownum, chickennum, goatnum,
    cowcount, chickencount, goatcount,num_of_labourers;
    public Image[] crop_placeholders;
    public Sprite blank;
    public List<Crops> uicrops;
    public Text[] cropprices;
    public Button sectog, unitog;


    [HideInInspector]
    public double total_income;
    public double total_expenses;
    #endregion
    #endregion

    void Start()
    {
        
        kids.Add(eldest);
        kids.Add(second);
        startamount = money;
        Year.text = years.ToString();

        foreach (Crops c in uicrops)
        {
            c.ToggleHandler();
        }
        #region Define parameters in Toggle_Handler
        health_insurance.GetComponent<Toggle_Handler>().money = HI_cost+HI_inperchild;
        birth_control.GetComponent<Toggle_Handler>().money = birth_control_cost;
        buy_car.GetComponent<Toggle_Handler>().money = car_cost;
        buy_house.GetComponent<Toggle_Handler>().money = house_cost;
        isterracebuilt.GetComponent<Toggle_Handler>().labor = 25;
        isdripirrigation.GetComponent<Toggle_Handler>().money = 50000;

        #endregion

        
            foreach (Children child in kids)
            {
                if (!child.primarycomplete)
                {

                }
                if (!child.sec_complete && child.primarycomplete)
                {
                    seckidsavailable += 1;
                }

                if (!child.uni_complete && child.sec_complete && child.primarycomplete)
                {
                    unikidsavailable += 1;
                }
            }
     
    }


    void Update()
    {
        
        chickennum.text = chickencount.text;
        goatnum.text = goatcount.text;
        cownum.text = cowcount.text;
        Money.text = money.ToString();
        Labor.text = labor.ToString();
        terraces.SetActive(isterracebuilt.isOn);
        grass_strips.SetActive(isgrassstripplaced.isOn);
        num_of_labourers.text = labourers.ToString();
        applymanure.interactable= number_of_chickens==15 || number_of_cows==1 || number_of_goats==5 ;
        for (int i = 0; i < cropprices.Length; i++)
        {
            cropprices[i].text= uicrops[i].seed_cost.ToString();
            
        }

        sectog.interactable = !(sec_kids >= seckidsavailable);
        unitog.interactable = !(uni_kids >= unikidsavailable);
 
        seckidstext.text = sec_kids.ToString();
        unikidstext.text = uni_kids.ToString();
        secavai.text = seckidsavailable.ToString();
        uniavai.text = unikidsavailable.ToString();
    }

    #region Livestock Functions
    
    public void Add_livestock( Livestock type)
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
            
            if (number_of_chickens == type.max) {
                
            return; }
        }
        if (type.type == "Goat")
        {
            if (number_of_goats == type.max) { 
            return; }
        }

        if (money >= type.cost)
        {
            money -= type.cost;
            total_expenses += type.cost;
            
        }
        else {
            Nomoney.SetActive(true);
            return;
        }
        if (labor >= type.required_labor)
        {
            labor -= type.required_labor;
            
        }
        else
        {
            Nolabour.SetActive(true);
            return;
        }
        
        if (type.type == "Cow") {
            number_of_cows += 1;
            cowcount.text = number_of_cows.ToString();
            newcow += 1;
            
        }

        if (type.type == "Goat") {
            number_of_goats += 1;
            goatcount.text = number_of_goats.ToString();
            newgoat += 1;

        }
        if (type.type == "Chicken") {
            number_of_chickens += 1;
            newchicken += 1;
            chickencount.text = number_of_chickens.ToString();
            

        }  
     }

    public void Remove_livestock(Livestock type)
    {
       if (type.type == "Cow" & number_of_cows>=1)
        {
            number_of_cows -= 1;
            if (newcow == 0)
            {
                money += type.cost-(type.cost*(10d/100d));
            }
            else { newcow -= 1; money += type.cost; }
            labor += type.required_labor;
            //total_expenses -= type.cost;
            cowcount.text = number_of_cows.ToString();
        }

        if (type.type == "Goat" & number_of_goats>=1)
        {
            number_of_goats -= 1;
            if (newgoat == 0)
            {
                money += type.cost - (type.cost * (10d / 100d));
            }
            else { newgoat -= 1; money += type.cost; }
            labor += type.required_labor;
           // total_expenses -= type.cost;
            goatcount.text = number_of_goats.ToString();
        }
        if (type.type == "Chicken" & number_of_chickens>=1)
        {
            number_of_chickens -= 1;
            if (newchicken == 0)
            {
                money += type.cost - (type.cost * (10d / 100d));
            }
            else { newchicken -= 1; money += type.cost; }
            labor += type.required_labor;
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
    #endregion

    #region Crop Functions
    public void PurchaseCrops(Crops type)
    {   if (crops.Count <= 9)
        {
            
            if (money >= type.seed_cost)
            {
                money -= type.seed_cost;
                total_expenses += type.seed_cost;

            }
            else
            {
                Nomoney.SetActive(true);
                return;
            }
            if (labor >= type.required_labor)
            {
                labor -= type.required_labor;
            }
            else
            {
                Nolabour.SetActive(true);
                return;
            }
            crops.Add(type);
            foreach (Crops c in uicrops)
            {
                c.num = 0;
                for (int i = 0; i < crops.Count; i++)
                {
                    if (crops[i] == c)
                    {
                        c.num++;
                    }

                }
                //c.displaynumber.text = c.num.ToString();
                //c.area = (c.num / 10) * 100;
            }
            for (int i = 0; i < crops.Count; i++)
            {
                
                if (crops[i] != null)
                {
                    crop_placeholders[i].sprite = crops[i].sprite;
                }
                else
                {
                    crop_placeholders[i].sprite = blank;
                }
            }

        }
    }

    public void  SellCrops(Crops type)
    {
        if (!crops.Contains(type))
        {
            return;
        }
        money += type.seed_cost;
        total_expenses -= type.seed_cost;
        labor += type.required_labor;
        
        //crop_placeholders[crops.LastIndexOf(type)].sprite=blank;
        crops.Remove(type);
        foreach (Crops c in uicrops)
        {
            c.num = 0;
            for (int i = 0; i < crops.Count; i++)
            {
                if (crops[i] == c)
                {
                    c.num++;
                }
                
            }
           // c.displaynumber.text = c.num.ToString();
            //c.area = (c.num / 10) * 100;
        }
        for (int i = 0; i < crops.Capacity; i++)
        {
            crop_placeholders[i].sprite = blank;
            
        }
        for (int i = 0; i < crops.Count; i++)
        {

            if (crops[i] != null)
            {
                crop_placeholders[i].sprite = crops[i].sprite;
            }
            else
            {
                crop_placeholders[i].sprite = blank;
            }
        }
    }
    
    #endregion

    #region Family

    public void School(int grade)
    {
        if (grade ==0 )
        {
            if (money > school_fees)
            {
                seckidsavailable--;
                sec_kids++;
                
            }
            else
            {
            Nomoney.SetActive(true);
            }
        }
        
        if (grade ==1)
        {
            if (money > school_fees * 1.5)
            {
                unikidsavailable--;
                uni_kids++;
                labor -= 50;
            }
            else
            {
                Nomoney.SetActive(true);
            }
        }
        
    }
    
    public  void RevomeSchool(int grade)
    {
        if (grade == 0)
        {
            if (sec_kids>0)
            {
                seckidsavailable ++;
                sec_kids --;
            }
        }
        if (grade == 1)
        {
            if (uni_kids > 0)
            { 
                unikidsavailable ++;
                uni_kids --;
                labor += 50;
            }
        }
    }
    public int FamilyExpense()
    {
        int expenses=0;
        if (health_insurance.isOn)
        {
           expenses+= HI_cost + kids.Count * HI_inperchild;
        }
        if (birth_control.isOn)
        {
            expenses += birth_control_cost;
        }
        if (buy_house.isOn)
        {
            expenses += house_cost;
        }
        if (buy_car.isOn)
        {
            expenses += car_cost;
        }
        expenses += school_fees*sec_kids+((school_fees*2)*uni_kids);
        expenses += basic_expenses + (increment_per_child * kids.Count);
        
        return expenses;

    }
    public int FamilyRevenue()
    {
        int revenue = 0;
        foreach (Children kid in kids)
        {
            if (kid.uni_complete)
            {
                revenue += 700;
            }
        }
        return revenue;
    }


    #endregion

    #region Labour
    public void AddLabour()
    {
        labourers += 1;
        labor += 80;
        money -= labor_cost;
    }
    public void RemoveLabour()
    {
        labourers -= 1;
        labor -= 80;
        money -= labor_cost;
    }
    #endregion


    #region Annual Review
    #region variables
    [Header (" Annual Review UI")]
    public GameObject panel;
    
    public AutoList CropIncomeList, CropExpenseList;
    public Text t_expenses, t_income, start_amount, year, household, net_total,
    livestock_expense, livestock_income,labor_income,labor_expense,living_expense,
    health_bills,child_pension,event_text;
    public Image net;
    public Image farmzy;
    public int healthbills;

    int terrace_stage;
    public GameObject terrace_maintenace_request,newbaby;
    int living_increase;
    #endregion
    public void Play()
    {
        Event();
        double totalincome = 0D;
        double totalexpense = 0D;
        double laborincome = 0D;
        double laborexpense = 0D;
        
        if (isofffarmjob.isOn)
        {
            laborincome = off_farm_job;
        }
        laborexpense = labourers * labor_cost;
        
        start_amount.text = startamount.ToString();
       

        household.text = "2 Adults + " +kids.Count.ToString()+ " Children";
      
        livestock_income.text = LivestockIncome().ToString();
        livestock_expense.text = LivestockExpense().ToString();
        labor_income.text = laborincome.ToString();
        labor_expense.text = laborexpense.ToString();
        child_pension.text = FamilyRevenue().ToString();
        
        living_expense.text = FamilyExpense().ToString();
        health_bills.text = healthbills.ToString();
        
        foreach (Crops c in uicrops)
        {

            c.totalincome = (c.num * (c.base_yield *(fertility/100d))* c.unitprice);

            c.totalincome -= (c.totalincome * (c.loss / 100d));
            c.totalincome += (c.totalincome * (c.profit/100d));

            if (c.pesticide.isOn) { c.totalexpense += c.pest_price; }
            totalexpense += c.totalexpense;
            totalincome += c.totalincome;
        }
           CropIncomeList.Populate();
           CropExpenseList.Populate();
        
        totalexpense += LivestockExpense() + FamilyExpense() + healthbills+laborexpense;
        totalincome  += LivestockIncome() + FamilyRevenue() + laborincome;
        
        t_expenses.text = totalexpense.ToString();
        t_income.text   = totalincome.ToString();
      
        startamount += System.Convert.ToInt32(totalincome -totalexpense);
       
        net_total.text = startamount.ToString();
        money= startamount;
        if (money>0)
        {
            net.color = Color.green;
        }
        else
        {
            net.color = Color.red;
        }
        
        #region Fertility and salinity
        if (isdripirrigation.isOn)
        {
            salinity += 25;
        }
        
        fertility -= 15;
        if (salinity==75)
        {
            fertility -= 50;
        }
        if (salinity==100)
        {
            fertility = 0;
        }
        if (washfield.isOn)
        {
            salinity = 0;
        }
        if (isgrassstripplaced.isOn)
        {
            fertility += 5;
        }
        if (applymanure.isOn)
        {
            fertility += 15;
        }
        #endregion
        Fertility.text = fertility.ToString();
        panel.SetActive(true);
        
       
        if (years<=12)
        {
            years++;
            Year.text = years.ToString();
        }
        else
        {
            End();
        }
    }
    public void NewYear()
    {
        labor = 250;
        unikidsavailable = 0;
        seckidsavailable = 0;

        foreach (Children child in kids)
        {
            if (!child.uni_complete )
            {
                if (child.sec_complete && child.primarycomplete)
                {
                    unikidsavailable++;
                    if (uni_kids >= 1)
                    {
                        child.stage_in_school++;
                        uni_kids--;

                    }
                    if (child.stage_in_school == 4)
                    {
                        child.uni_complete = true;
                        //unikidsavailable--;
                    }
                }
            }
            if (!child.sec_complete)
            {
                
                if (child.primarycomplete)
                {   seckidsavailable++;
                    if (sec_kids >= 1)
                    {
                        child.stage_in_school++;
                        sec_kids--;
                    }
                    if (child.stage_in_school == 6)
                    {
                        child.sec_complete = true;
                        child.stage_in_school = 0;
                        seckidsavailable--;
                    }
                }
            }
            child.age++;
            if (child.age>= 18)
            {
                labor += 50;
            }

        }
        if (!birth_control.isOn)
        {
            int chance = Random.Range(0, 11);
            if (chance>=5)
            {
                Children baby = new Children(1, 0, false, false, false);
                kids.Add(baby);
                newbaby.SetActive(true);
            }
        }
       
        foreach (Crops c in uicrops)
        {
            c.loss = 0;
            c.totalexpense = 0;
            c.totalincome = 0;
            c.num = 0;
        }
         
        healthbills = 0;
        newchicken = 0;
        newgoat = 0;
        newcow = 0;
        labourers = 0;
        if (isterracebuilt.isOn && terrace_stage==0)
        {
            terrace_stage = 1;
            terrace_maintenace_request.SetActive(true);
        }
        if (terrace_stage==1 && isterracemaintained )
        {
            terrace_stage = 2;
            isterracebuilt.isOn = true;
            isterracebuilt.interactable = false;
        }
        if (buy_car.isOn)
        {
            buy_car.interactable = false;
        }
        if (buy_house.isOn)
        {
            buy_house.interactable = false;
        }
        var toggles = FindObjectsOfType<Toggle>();
        foreach (var toggle in toggles)
        {
            toggle.isOn = false;
        }
    }
    public void Event()
    {
      
        Events events = new Events();
        int evento = Random.Range(0, 6);

        if (evento == 0)
        {
            events = new Disease();
        }

        if (evento == 1)
        {
            events = new Drought();
        }
        if (evento == 2)
        {
            events = new Gullying();
        }
        if (evento == 3)
        {
            events = new Illness();
        }
        if (evento == 4)
        {
            events = new Insects();
        }
        if (evento == 5)
        {
            events = new LivingCosts();
        }
        if (evento == 0)
        {
            events = new LowmarketPrice();
        }
        events.Operation(s_Instance);
    }
    public void End()
    {

    }
    public void TerraceMaintenace()
    {
        isterracebuilt.isOn = true;
        isterracemaintained = true;
       
    }
    #endregion
    //to do upgrades and manure

   
}
