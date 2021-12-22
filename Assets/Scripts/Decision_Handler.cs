using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Decision_Handler : MonoBehaviour
{
    #region variables
    //static public Decision_Handler instance { get { return s_Instance; } }
    public Decision_Handler s_Instance;
    public Livestock_Handler Livestock_Handler;
    public Crop_Handler Crop_Handler;
    [Header("Farm parameters")]
    #region 
    //public List<Crops> crops = new List<Crops>(10);
    public double money = 100000d;
    public double fertility=60d;
    public int salinity;
    public int labor=250; 
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
    public GameObject Nomoney,Nolabour, Endpanel;
    public Text Money, Fertility, Salinity, Labor, Year,  num_of_labourers;
    
    public Button sectog, unitog;
    #endregion
    #endregion

    void Start()
    {
        
        kids.Add(eldest);
        kids.Add(second);
        startamount = money;
        Year.text = years.ToString()+"12";

        
        #region Definition of parameters in Toggle_Handler
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
        Money.text = money.ToString();
        Labor.text = labor.ToString();
        terraces.SetActive(isterracebuilt.isOn);
        grass_strips.SetActive(isgrassstripplaced.isOn);
        num_of_labourers.text = labourers.ToString();
        applymanure.interactable= Livestock_Handler.number_of_chickens==15
                                 || Livestock_Handler.number_of_cows >= 1 
                                 || Livestock_Handler.number_of_goats >= 8 ;
        

        sectog.interactable = !(sec_kids >= seckidsavailable);
        unitog.interactable = !(uni_kids >= unikidsavailable);
 
        seckidstext.text = sec_kids.ToString();
        unikidstext.text = uni_kids.ToString();
        secavai.text = seckidsavailable.ToString();
        uniavai.text = unikidsavailable.ToString();
    }

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
            if (money > school_fees * 1.5 )
            {
                if (labor>=50)
                {
                    unikidsavailable--;
                    uni_kids++;
                    labor -= 50;
                }
                else
                {
                    Nolabour.SetActive(true);
                }
                
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
    public Image farmzy, eventImage;
    public int healthbills, end_in_debt;

    int terrace_stage;
    public GameObject terrace_maintenace_request,newbaby;
    int living_increase;
    public Sprite[] eventSprites;
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
      
        livestock_income.text = Livestock_Handler.LivestockIncome().ToString();
        livestock_expense.text = Livestock_Handler.LivestockExpense().ToString();
        labor_income.text = laborincome.ToString();
        labor_expense.text = laborexpense.ToString();
        child_pension.text = FamilyRevenue().ToString();
        
        living_expense.text = FamilyExpense().ToString();
        health_bills.text = healthbills.ToString();
        
        foreach (Crops c in Crop_Handler.uicrops)
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
        
        totalexpense += Livestock_Handler.LivestockExpense() + FamilyExpense() + healthbills+laborexpense;
        totalincome  += Livestock_Handler.LivestockIncome() + FamilyRevenue() + laborincome;
        
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
        if (fertility<0)
        {
            fertility = 0;
        }
         Fertility.text = fertility.ToString();
        #endregion
       
        panel.SetActive(true);
        
       
        if (years<=12)
        {
            print(years);
            years++;
            Year.text = years.ToString()+"/12";
        }
      
    }
    public void NewYear()
    {
        if (end_in_debt==2)
        {
            Endpanel.GetComponent<End>().GameOver("lose");
            return;
        }
        if (years <= 12)
        {
            years++;
            Year.text = years.ToString() + "/12";
            labor = 150;
            unikidsavailable = 0;
            seckidsavailable = 0;

            foreach (Children child in kids)
            {
                if (!child.uni_complete)
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
                    {
                        seckidsavailable++;
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
                if (child.age >= 18)
                {
                    labor += 50;
                }

            }
            if (!birth_control.isOn)
            {
                int chance = Random.Range(0, 11);
                if (chance >= 5)
                {
                    Children baby = new Children(1, 0, false, false, false);
                    kids.Add(baby);
                    newbaby.SetActive(true);
                }
            }

            Crop_Handler.NewYear();

            healthbills = 0;
            Livestock_Handler.newchicken = 0;
            Livestock_Handler.newgoat = 0;
            Livestock_Handler.newcow = 0;
            labourers = 0;
            if (isterracebuilt.isOn && terrace_stage == 0)
            {
                terrace_stage = 1;
                terrace_maintenace_request.SetActive(true);
            }
            if (terrace_stage == 1 && isterracemaintained)
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
        else
        {
            var toggles = FindObjectsOfType<Toggle>();
            foreach (var toggle in toggles)
            {
                toggle.isOn = false;
            }
            panel.SetActive(false);
            Endpanel.SetActive(true);
            string endresult="bad";
            if (fertility>=80 && money>=50000)
            {
                endresult = "good";
                if (kids[0].uni_complete && kids[1].sec_complete)
                {
                    endresult = "very good";
                }
            }
            End end = Endpanel.GetComponent<End>();
            end.GameOver(endresult);
        }
    }
    public void Event()
    {
      
        Events events = new Events();
        int evento = Random.Range(0, 6);
        if(eventSprites[evento]!=null)
        {
            eventImage.sprite=eventSprites[evento];
        }
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
            eventImage.sprite=eventSprites[0];
            
        }
        if (evento == 0)
        {
            events = new LowmarketPrice();
        }
        events.Operation(s_Instance);
    }
   
    public void TerraceMaintenace()
    {
        isterracebuilt.isOn = true;
        isterracemaintained = true;
       
    }
    #endregion

     public void Rerun( )
    {
        money = 100000;

        labor = 250;
        Crop_Handler.NewYear();
        Livestock_Handler.NewGame();
        fertility = 60;
        kids.Clear();
        kids.Add(eldest);
        kids.Add(second);
        years = 1;
    }
    //to do end

   
}
