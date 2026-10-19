table 50455 "Checkoff Header"
{
    DrillDownPageID = "Remittance List";
    LookupPageID = "Remittance List";

    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                TestNoSeries();

            end;
        }
        field(50010; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50011; "Date Entered"; Date)
        {
            Editable = false;
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50012; "Time Entered"; Time)
        {
            Editable = false;
            Caption = 'Time Entered';
            DataClassification = CustomerContent;
        }
        field(50013; "Entered By"; Code[50])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50014; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Posting Date" > Today then
                    Error('Posting Date cannot be in the Future');
            end;
        }
        field(50015; "Account Type"; Enum "Gen. Journal Account Type")
        {
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50016; "Account No."; Code[20])
        {
            TableRelation = if ("Account Type" = filter(Customer)) Customer."No." where("Account Type" = filter('Employer')) else
            if ("Account Type" = filter("Bank Account")) "Bank Account" where(Blocked = filter(false));
        
            trigger OnValidate()
            begin

                case "Account Type" of
                    "Account Type"::Customer:
                        begin
                            if Customer.Get("Account No.") then begin
                                "Account Name" := Customer.Name;
                                Customer.CalcFields(Balance, "Balance (LCY)");
                                Balance := Abs(Customer."Balance (LCY)")
                            end;
                        end;
                    "Account Type"::"Bank Account":
                        begin
                            if BankAccount.Get("Account No.") then begin
                                BankAccount.CalcFields(Balance, "Balance (LCY)");
                                "Account No." := BankAccount."No.";
                                "Account Name" := BankAccount.Name;
                                Balance := BankAccount."Balance (LCY)";
                            end;
                        end;
                    else
                        "Account Name" := '';
                end;
            end;
        }
        field(50017; "Account Name"; Text[50])
        {
            Caption = 'Agency  Name';
            DataClassification = CustomerContent;
        }
        field(50018; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50020; "Scheduled Amount"; Decimal)
        {
            CalcFormula = Sum("Checkoff Receipt Lines".Amount WHERE("Account Found" = CONST(true),
                                                                     "No." = FIELD("No.")));
            // DecimalPlaces is unspecified in the supplied symbols.
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Scheduled Amount';
        }
        field(50021; "Employer Code"; Code[20])
        {
            TableRelation = Customer;
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Customer.Get("Employer Code") then begin
                    "Employer Name" := Customer.Name;
                end else
                    "Employer Name" := '';
            end;
        }
        field(50022; "Employer Name"; Text[50])
        {
            Editable = false;
            Caption = 'Employer Name';
            DataClassification = CustomerContent;
        }
        field(50023; "Account Found"; Integer)
        {
            CalcFormula = Count("Checkoff Receipt Lines" WHERE("Account Found" = CONST(true),
                                                                "No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Account Found';
        }
        field(50024; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50025; "Posted"; Boolean)
        {
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50026; "Approval Status"; Enum "ApprovalStatus")
        {
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50027; "Posted Record"; Integer)
        {
            CalcFormula = Count("Checkoff Receipt Lines" WHERE(Posted = CONST(true),
                                                                "No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Posted Record';
        }
        field(50028; "Vendor No"; Code[20])
        {
            TableRelation = Vendor;
            Caption = 'Vendor No';
            DataClassification = CustomerContent;
        }
        field(50029; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(1,"Shortcut Dimension 1 Code");
            end;
        }
        field(50030; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                //ValidateShortcutDimCode(2,"Shortcut Dimension 2 Code");
            end;
        }
        field(50031; "Responsibility Centre"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center".Code;
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50032; "Cutoff Date"; Date)
        {
            Caption = 'Cutoff Date';
            DataClassification = CustomerContent;
        }
        field(50033; "Interest Cutoff Date"; Date)
        {
            Caption = 'Interest Cutoff Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50034; "Date Posted"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Posted';
        }
        field(50035; "Time Posted"; Time)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Time Posted';
        }
        field(50036; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50037; "Application Type"; Enum "CheckoffTypes")
        {
            DataClassification = CustomerContent;
            Caption = 'Application Type';
        }
        field(50038; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Checkoff Receipt Lines".Amount WHERE("No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Amount';
        }
        field(50039; "Accoun Not Found"; Integer)
        {
            CalcFormula = Count("Checkoff Receipt Lines" WHERE("No." = FIELD("No."),
                                                                "Account Found" = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Accoun Not Found';
        }
        field(50040; "Record Not Posted"; Integer)
        {
            CalcFormula = Count("Checkoff Receipt Lines" WHERE("No." = FIELD("No."),
                                                                Posted = CONST(false)));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Record Not Posted';
        }
        field(50041; "Loan Deduction Type"; Enum "CheckoffLoanDeductType")
        {
            DataClassification = CustomerContent;
            Caption = 'Loan Deduction Type';
        }
        field(50042; "Product Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Product Type';
        }
        field(50043; "Post As"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Post As Lines,Post As Batch';
            OptionMembers = " ","Post As Lines","Post As Batch";
            Caption = 'Post As';
        }
        field(50044; "Posting Type"; Option)
        {
            OptionMembers = " ","Post Application","Generate Batch";
            OptionCaption = ' ,Post Application,Generate Batch';
        }
        field(50045; "Balance"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }

        field(50046; "Advice Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = "Full Amount","Half Amount";
        }
        field(50047; "Value Post"; Boolean)
        {
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(50048; "Deduction Type"; Enum "CheckOffDeductType")
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                case "Deduction Type" of
                    "Deduction Type"::Account,
                    "Deduction Type"::"All Products":
                        begin
                            "Loan Deduction Type" := "Loan Deduction Type"::" ";
                        end;
                end;
            end;
        }

        field(50049; "Post Business Loan"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Post Business Loan (Separately)';
        }
        field(50050; "Total Interest"; Decimal)
        {
            CalcFormula = Sum("Checkoff Receipt Lines"."Interest Repayment" where("No." = field("No.")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'Total Interest';
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
            NoSetup.Get();
            NoSetup.TestField(NoSetup."Checkoff No.");
            "No. Series" := NoSetup."Checkoff No.";
            if NoSeriesMgt.AreRelated(NoSetup."Checkoff No.", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series")

        end;

        "Date Entered" := Today;
        "Time Entered" := Time;
        "Entered By" := UserId;
        "Document No." := "No.";
        "Posting Date" := Today;

        Temp.Get(UserId);
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        Temp.TestField("Responsibility Centre");
        "Shortcut Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Shortcut Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Responsibility Centre" := Temp."Responsibility Centre";
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Checkoff Header";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                NoSetup.Get();
                NoSeriesMgt.TestManual(NoSetup."Checkoff No.");
                "No. Series" := '';
            end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Checkoff Header"; xRecRef: Record "Checkoff Header"; var IsHandled: Boolean)
    begin
    end;

    trigger OnModify()
    begin
        if Rec.Posted = true then
            Error('You cannot Modify/Delete a record that is already Posted');
    end;





    var
        NoSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        Customer: Record Customer;
        BankAccount: Record "Bank Account";
        Temp: Record "User Setup";

    [IntegrationEvent(false, false)]
    procedure OnBeforePerformPostOnCheckoffHeader(var RecRef: Record "Checkoff Header"; CallingFieldNo: Integer)
    begin


    end;

    [IntegrationEvent(false, false)]

    procedure OnBeforeReverseEntriesOnPostHeader(var RecRef: Record "Checkoff Header"; CallingFieldNo: Integer)
    begin


    end;


    procedure RequiredItems()
    begin
        TestField(Description);
        TestField(Amount);
        TestField("Posting Date");
        TestField("Account No.");
        TestField("Post As");
        TestField(Posted, false);
    end;


    procedure RequiredItemsPost()
    begin
        TestField(Description);
        TestField(Amount);
        TestField("Posting Date");
        TestField("Account No.");
        TestField("Post As");
        TestField(Posted, false);
        TestField("Approval Status", "Approval Status"::Approved);
    end;
}




