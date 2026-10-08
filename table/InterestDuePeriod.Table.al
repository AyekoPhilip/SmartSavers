table 50489 "Interest Due Period"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Interest Due Date"; Date)
        {
            Caption = 'Interest Due Date';
            Editable = false;
            NotBlank = true;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Name := Format("Interest Due Date", 0, Text000);
            end;
        }
        field(50010; "Name"; Text[10])
        {
            Caption = 'Name';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50011; "New Fiscal Year"; Boolean)
        {
            Caption = 'New Fiscal Year';
            Editable = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Date Locked", false);
                if "New Fiscal Year" then begin
                    if not InvtSetup.Get then
                        exit;
                    "Average Cost Calc. Type" := InvtSetup."Average Cost Calc. Type";
                    "Average Cost Period" := InvtSetup."Average Cost Period";
                end else begin
                    "Average Cost Calc. Type" := "Average Cost Calc. Type"::" ";
                    "Average Cost Period" := "Average Cost Period"::" ";
                end;
            end;
        }
        field(50012; "Closed"; Boolean)
        {
            Caption = 'Closed';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if xRec.Closed = true then
                    Error('You canot reopen Closed Period');
                "Closed by User" := UserId;
                "Closing Date Time" := Today;
                Modify;
            end;
        }
        field(50013; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50014; "Average Cost Calc. Type"; Enum "Average Cost Calculation Type")
        {
            Caption = 'Average Cost Calc. Type';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50015; "Average Cost Period"; Option)
        {
            Caption = 'Average Cost Period';
            Editable = false;
            OptionCaption = ' ,Day,Week,Month,Quarter,Year,Accounting Period';
            OptionMembers = " ","Day","Week","Month","Quarter","Year","Accounting Period";
            DataClassification = CustomerContent;
        }
        field(50016; "Closed by User"; Code[20])
        {
            Editable = false;
            Caption = 'Closed by User';
            DataClassification = CustomerContent;
        }
        field(50017; "Closing Date Time"; Date)
        {
            Editable = false;
            Caption = 'Closing Date Time';
            DataClassification = CustomerContent;
        }
        field(50018; "Posting Document No."; Code[20])
        {
            Editable = false;
            Caption = 'Posting Document No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Interest Calcuation Date"; Date)
        {
            Caption = 'Interest Calculation Date';
            Editable = false;
            NotBlank = true;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Name := Format("Interest Due Date", 0, Text000);
            end;
        }
        field(50020; "Period End Date"; Date)
        {
            Editable = false;
            Caption = 'Period End Date';
            DataClassification = CustomerContent;
        }
        field(50021; "No of Days"; Integer)
        {
            Editable = false;
            Caption = 'No of Days';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Interest Due Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField("Date Locked", false);
        UpdateAvgItems(3);
    end;

    trigger OnInsert()
    begin

        AccountingPeriod2 := Rec;
        if AccountingPeriod2.Find('>') then
            AccountingPeriod2.TestField("Date Locked", false);
        UpdateAvgItems(1);
    end;

    trigger OnModify()
    begin
        UpdateAvgItems(2);
    end;

    trigger OnRename()
    begin

        TestField("Date Locked", false);
        AccountingPeriod2 := Rec;
        if AccountingPeriod2.Find('>') then
            AccountingPeriod2.TestField("Date Locked", false);
        UpdateAvgItems(4);
    end;

    var
        AccountingPeriod2: Record "Interest Due Period";
        InvtSetup: Record "Inventory Setup";
        Text000: Label '<Month Text>';


    procedure UpdateAvgItems(UpdateType: Option)
    begin
        //ChangeAvgCostSetting.UpdateAvgCostFromAccPeriodChg(Rec,xRec,UpdateType);
    end;
}




