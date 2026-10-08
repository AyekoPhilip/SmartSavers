table 50378 "Standing Order Header"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
               
            end;
        }
        field(50010; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50011; "No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50012; "Approval Status"; Enum "STOApprovalStatus")
        {
            Editable = true;
            Caption = 'Status';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                StandingOrderLine: Record "Standing Order Lines";
            begin
                StandingOrderLine.Reset();
                StandingOrderLine.SetRange("Document No.", "No.");
                if StandingOrderLine.FindSet() then begin
                    StandingOrderLine.ModifyAll(Status, "Approval Status");
                end;

            end;
        }
        field(50013; "Transaction Branch"; Code[10])
        {
            Caption = 'Transaction Branch';
            DataClassification = CustomerContent;
        }
        field(50014; "Responsibility Center"; Code[20])
        {
            Enabled = false;
            TableRelation = "Responsibility Center";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50015; "Source Account Type"; Enum "CreditAccountTypes")
        {
            Caption = 'Source Account Type';
            DataClassification = CustomerContent;
        }
        field(50016; "Source Account No."; Code[20])
        {
            Caption = 'Source Account No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("Source Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Source Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Account Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Source Account Type" = CONST("IC Partner")) "IC Partner"
            ELSE
            IF ("Source Account Type" = CONST(Savings)) "Account Banking" where(Status = filter(Active | New | Dormant | Defaulter | Withdrawn | Blocked), "Account Category" = filter(Savings | Junior))
            ELSE
            IF ("Source Account Type" = CONST(Credit)) "Account Credit" where(Status = filter(Active | New | Dormant | Defaulter | Withdrawn | Blocked))
            ELSE
            IF ("Source Account Type" = CONST(Loan)) "Credit Account" where(Status = filter(Active | New | Dormant | Defaulter | Withdrawn | Blocked))
            ELSE
            IF ("Source Account Type" = CONST(Prepayment)) "Repayment Account";
        
            trigger OnValidate()
            begin
                if "Source Account Type" <> "Source Account Type"::Savings then
                    Error('Invalid Option selected');

                if Account.Get("Source Account No.") then begin
                    "Payroll/Staff No." := Account."Staff/Payroll No.";
                    "Source Account Name" := Account.Name;
                    "Member No." := Account."Member No.";
                    "ID Number" := Account."ID/Passport No.";
                end;
            end;
        }
        field(50017; "Source Account Name"; Text[80])
        {
            Editable = false;
            Caption = 'Source Account Name';
            DataClassification = CustomerContent;
        }
        field(50018; "Member No."; Code[10])
        {
            Editable = false;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50019; "ID Number"; Code[20])
        {
            Editable = false;
            Caption = 'ID Number';
            DataClassification = CustomerContent;
        }
        field(50020; "Payroll/Staff No."; Code[20])
        {
            Editable = false;
            Caption = 'Payroll/Staff No.';
            DataClassification = CustomerContent;
        }
        field(50021; "Description"; Text[50])
        {
            Description = 'LookUp to Standing Orders Description Table';
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50022; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //if "Allocated Amount" > 0 then
                //TestField(Amount,"Allocated Amount");
            end;
        }
        field(50023; "Allocated Amount"; Decimal)
        {
            CalcFormula = Sum("Standing Order Lines".Amount WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Allocated Amount';
        }
        field(50024; "Balance"; Decimal)
        {
            Editable = false;
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }
        field(50025; "Standing Order Type"; Option)
        {
            OptionCaption = 'Internal,External,Pensioner';
            OptionMembers = "Internal","External","Pensioner";
            Caption = 'Standing Order Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Standing Order Type" = "Standing Order Type"::Pensioner then
                    Priority := 1
                else
                    if "Standing Order Type" = "Standing Order Type"::Internal then
                        Priority := 2
                    else
                        if "Standing Order Type" = "Standing Order Type"::External then
                            Priority := 3;
            end;
        }
        field(50026; "Allow Partial Deduction"; Boolean)
        {
            Caption = 'Allow Partial Deduction';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                STOLines.Reset;
                STOLines.SetRange("Document No.", "No.");
                STOLines.SetRange(STOLines."Destination Account Type", STOLines."Destination Account Type"::"Bank Account");
                if STOLines.Find('-') then begin

                    if STOLines."Destination Account Type" = STOLines."Destination Account Type"::"Bank Account" then
                        Error('An external standing order cannot be partially deducted');
                end;
            end;
        }
        field(50027; "None Salary"; Boolean)
        {
            Enabled = false;
            Caption = 'None Salary';
            DataClassification = CustomerContent;
        }
        field(50028; "Income Type"; Option)
        {
            OptionCaption = 'Periodic,Salary,Pension,Milk,Tea,Coffee';
            OptionMembers = "Periodic","Salary","Pension","Milk","Tea","Coffee";
            Caption = 'Income Type';
            DataClassification = CustomerContent;
        }
        field(50029; "Type"; Option)
        {
            OptionCaption = ' ,Fixed,Sweep';
            OptionMembers = " ","Fixed","Sweep";
            Caption = 'Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                StndingOrders.Reset;
                StndingOrders.SetRange(StndingOrders."Source Account No.", "Source Account No.");
                StndingOrders.SetRange(StndingOrders."Approval Status", StndingOrders."Approval Status"::Approved);
                StndingOrders.SetRange(StndingOrders.Type, Type);
                if StndingOrders.Find('-') then begin
                    Error('This member has another standing order of Type %1', StndingOrders.Type);
                end;

                if Type = Type::Sweep then
                    Amount := 0;
            end;
        }
        field(50030; "Priority"; Decimal)
        {
            Caption = 'Priority';
            DataClassification = CustomerContent;
        }
        field(50031; "Effective/Start Date"; Date)
        {
            Caption = 'Effective/Start Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Effective/Start Date" < Today then
                    Error('Date must be in Today or in future');

                "Next Run Date" := CalcDate("Frequency (Months)", "Effective/Start Date");
            end;
        }
        field(50032; "Frequency (Months)"; DateFormula)
        {
            Caption = 'Frequency (Months)';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin


                "Next Run Date" := CalcDate("Frequency (Months)", "Effective/Start Date");

            end;
        }
        field(50033; "Duration (Months)"; DateFormula)
        {
            Caption = 'Duration (Months)';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestField("Effective/Start Date");
                TestField("Frequency (Months)");
                TestField("Duration (Months)");

                Evaluate(DurationText, Format("Duration (Months)"));
                DurationText := DelChr(Format(DurationText), '=', '-|+|');
                Evaluate("Duration (Months)", DurationText);
                "End Date" := CalcDate("Duration (Months)", "Effective/Start Date");

            end;
        }
        field(50034; "End Date"; Date)
        {
            Editable = true;
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50035; "Effected"; Boolean)
        {
            Editable = false;
            Caption = 'Effected';
            DataClassification = CustomerContent;
        }
        field(50036; "Unsuccessfull"; Boolean)
        {
            Editable = false;
            Caption = 'Unsuccessfull';
            DataClassification = CustomerContent;
        }
        field(50037; "Next Run Date"; Date)
        {
            Caption = 'Next Run Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50038; "Auto Process"; Boolean)
        {
            Caption = 'Auto Process';
            DataClassification = CustomerContent;
        }
        field(50039; "Date Reset"; Date)
        {
            Editable = false;
            Caption = 'Date Reset';
            DataClassification = CustomerContent;
        }
        field(50040; "Invalid"; Boolean)
        {
            Caption = 'Invalid';
            DataClassification = CustomerContent;
        }
        field(50041; "Unrecovered"; Boolean)
        {
            Caption = 'Unrecovered';
            DataClassification = CustomerContent;
        }
        field(50042; "Created By"; Code[50])
        {
            Caption = 'Created By';
            DataClassification = CustomerContent;
        }
        field(50043; "Bank Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Bank Code";
            Caption = 'Bank Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //*
                BankCodes.Reset;
                BankCodes.SetRange(BankCodes."Bank Code", "Bank Code");
                if BankCodes.Find('-') then
                    "Bank Name" := BankCodes."Bank Name";

                //*
                if "Bank Code" = '' then begin
                    "Branch Code" := '';
                    "Bank Name" := '';
                    "Bank Account No." := '';
                end;
            end;
        }
        field(50044; "Branch Code"; Code[10])
        {
            TableRelation = "Bank Code Structure"."Branch Code" WHERE("Bank Code" = FIELD("Bank Code"));
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50045; "Bank Name"; Text[100])
        {
            Editable = false;
            Caption = 'Bank Name';
            DataClassification = CustomerContent;
        }
        field(50046; "Bank Account No."; Code[15])
        {
            Caption = 'Bank Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if StrLen("Bank Account No.") <> 13 then begin
                    Error('Invalid Bank account No. Please enter the correct Bank Account No.');
                end;
            end;
        }
        field(50047; "Transfered to EFT"; Boolean)
        {
            Description = 'Help Identify eft that has External transfer during eft processing';
            Caption = 'Transfered to EFT';
            DataClassification = CustomerContent;
        }
        field(50048; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Standing Order"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50049; "Activity Code"; Code[30])
        {
            Enabled = false;
            Caption = 'Activity Code';
            DataClassification = CustomerContent;
        }
        field(50050; "Global Dimension 1 Code"; Code[15])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
        }
        field(50051; "Global Dimension 2 Code"; Code[15])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
        }
        field(50052; "Responsibility Centre"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }

        field(50053; "Deduction Status"; Option)
        {
            OptionMembers = " ","Successfull","Partial Deduction","Failed";
            DataClassification = CustomerContent;
            Editable = false;
        }
    }

    keys
    {
        key("Key1"; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Standing Order Nos.");
            
        end;

        "Application Date" := Today;
        "Created By" := UserId;
        "Application Date":= Today;

        UserSetUp.Reset;
        UserSetUp.SetRange(UserSetUp."User ID", UserId);
        if UserSetUp.Find('-') then begin
            UserSetUp.TestField(UserSetUp."Global Dimension 1 Code");
            UserSetUp.TestField(UserSetUp."Global Dimension 2 Code");
            UserSetUp.TestField("Responsibility Centre");
            "Responsibility Centre" := UserSetUp."Responsibility Centre";
            "Global Dimension 1 Code" := UserSetUp."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetUp."Global Dimension 2 Code";

        end;
    end;

    var
        SeriesSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        StndingOrders: Record "Standing Order Header";
        Account: Record "Account Banking";
        BankCodes: Record "Bank Code Structure";
        DurationText: Text;
        STOLines: Record "Standing Order Lines";
        UserSetUp: Record "User Setup";
}




