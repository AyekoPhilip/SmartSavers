table 50471 "Collateral Register"
{
    DrillDownPageID = "Collateral Reg. Lookup Page";
    LookupPageID = "Collateral Reg. Lookup Page";
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[50])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
               
            end;
        }
        field(50010; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50011; "Account No."; Code[100])
        {
            TableRelation = Member where(Status = filter(Active));
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Account: Record "Account Banking";
            begin
                if CusMembr.Get("Account No.") then
                    CusMembr.TestField("ID No.");
                "Account Name" := CusMembr.Name;
                "PIN No." := CusMembr."PIN No.";
                "Phone No." := CusMembr."Mobile Phone No";
                "ID/Passport" := CusMembr."ID No.";
                Account.Reset();
                Account.SetRange("Member No.", Rec."Account No.");
                Account.SetRange("Account Category", Account."Account Category"::Savings);
                if Account.FindFirst() then begin
                    Rec."Savings Account No." := Account."No.";
                end;
                PassDocumentNo;
                "Captured By" := UserId;
                "Application Date" := CurrentDateTime;
                if "Document Type" = "Document Type"::Document then begin
                    GenSetup.Get();
                    GenSetup.TestField("Safe Custody Frequency");
                    "SC Duration" := GenSetup."Safe Custody Frequency";
                    "Maturity Date" := CalcDate(GenSetup."Safe Custody Frequency", Today)
                end
            end;
        }
        field(50012; "Account Name"; Text[250])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Collateral Type"; Enum "CollateralType")
        {
            Caption = 'Collateral Type';
            DataClassification = CustomerContent;
        }
        field(50014; "Collateral"; Code[10])
        {
            TableRelation = "Loan Securities Set-up".Code WHERE(Type = FIELD("Collateral Type"));
            Caption = 'Collateral';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if SecurityRegSetUp.Get(Collateral) then begin
                    if SecurityRegSetUp.Blocked then
                        Error(Text001, SecurityRegSetUp."Security Description");
                    "Collateral Name" := SecurityRegSetUp."Security Description";
                    "Collateral Multiplier" := SecurityRegSetUp."Collateral Multiplier";
                    "Collateral Limit" := "Collateral Value" * ("Collateral Multiplier" / 100);
                end;
            end;
        }
        field(50015; "Collateral Name"; Text[80])
        {
            Editable = false;
            Caption = 'Collateral Name';
            DataClassification = CustomerContent;
        }
        field(50016; "Collateral Multiplier"; Integer)
        {
            Editable = false;
            Caption = 'Collateral Multiplier';
            DataClassification = CustomerContent;
        }
        field(50017; "Collateral Value"; Decimal)
        {
            Caption = 'Collateral Value';
            DataClassification = CustomerContent;
        }
        field(50018; "Collateral Limit"; Decimal)
        {
            Editable = false;
            Caption = 'Collateral Limit';
            DataClassification = CustomerContent;
        }
        field(50019; "Approval Status"; Enum "ApprovalStatus")
        {
            Editable = false;
            Caption = 'Approval Status';
            DataClassification = CustomerContent;
        }
        field(50020; "Inward/Outward"; Option)
        {
            Editable = false;
            OptionCaption = ' ,In-Store,Withdrawn';
            OptionMembers = " ","In-Store","Returned";
            Caption = 'Inward/Outward';
            DataClassification = CustomerContent;
        }
        field(50021; "Last Valuation Date"; Date)
        {
            Caption = 'Last Valuation Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                GenSetup.Get;
                if "Last Valuation Date" <> 0D then begin
                    if "Last Valuation Date" > Today then
                        Error(Text004);
                    GenSetup.TestField("Maximum Valuation Period");
                    if CalcDate(GenSetup."Maximum Valuation Period", "Last Valuation Date") < Today then
                        Error(Text003, GenSetup."Maximum Valuation Period");
                    SecurityRegSetUp.Reset;
                    SecurityRegSetUp.SetRange(SecurityRegSetUp.Type, "Collateral Type");
                    if SecurityRegSetUp.Find('-') then begin
                        if Format(SecurityRegSetUp."Revaluation Frequency") <> '' then
                            "Next Valuation Date" := CalcDate(SecurityRegSetUp."Revaluation Frequency", "Last Valuation Date");
                    end;
                end;
            end;
        }
        field(50022; "Forced Sale Value"; Decimal)
        {
            Caption = 'Forced Sale Value';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Text001: Label 'Forced sale value cannot be more than collateral limit';
            begin
                "Collateral Limit" := "Collateral Value" * ("Collateral Multiplier" / 100)
            end;
        }
        field(50023; "Collateral Perfected"; Boolean)
        {
            Editable = true;
            Caption = 'Collateral Perfected';
            DataClassification = CustomerContent;
        }
        field(50024; "Next Valuation Date"; Date)
        {
            Editable = false;
            Caption = 'Next Valuation Date';
            DataClassification = CustomerContent;
        }
        field(50025; "Remarks"; Text[150])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50026; "Responsibility Center"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Center';
        }
        field(50027; "Application Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,Member,Guarantor';
            OptionMembers = " ","Member","Guarantor";
            Caption = 'Application Type';
        }
        field(50028; "Registration No."; Code[150])
        {
            DataClassification = CustomerContent;
            Caption = 'Registration No.';
        }
        field(50029; "Chasis No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Chasis No.';
        
            trigger OnValidate()
            begin
                RegMgt.CheckspecialCharacters("Engine No.")
            end;
        }
        field(50030; "Engine No."; Code[20])
        {
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                RegMgt.CheckspecialCharacters("Engine No.")
            end;
        }
        field(50031; "Year of Manufacture"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Year of Manufacture';
        }
        field(50032; "Car Model"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Car Model';
        }
        field(50033; "Car Make"; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Car Make';
        }
        field(50034; "Body Type"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Body Type';
        }
        field(50035; "ID/Passport"; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'ID/Passport';
        }
        field(50036; "Phone No."; Code[15])
        {
            DataClassification = CustomerContent;
            Editable = false;
            ExtendedDatatype = PhoneNo;
            Caption = 'Phone No.';
        }
        field(50037; "PIN No."; Code[20])
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'PIN No.';
        }
        field(50038; "Joint Ownership"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Joint Ownership';
        }
        field(50039; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(50040; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(50041; "Captured By"; Code[50])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Captured By';
        }
        field(50042; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
        field(50043; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Posted';
        }
        field(50044; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified Date';
        }
        field(50045; "Last Modified By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Last Modified By';
        }

        field(50046; "Insurance Value"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Insurance Value';
        }

        field(50047; "Property Type"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = true;
            Caption = 'Property Type';
            TableRelation = if ("Collateral Type" = filter(<> "Motor Vehicle")) "Property Type";
        }
        field(50048; "Application Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Application Date';
        }
        field(50049; "Policy No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50050; "Policy Start Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50051; "Policy End Date"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50052; "Annual Premium Amount"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50053; "Date Premium Last Paid"; Date)
        {
            DataClassification = CustomerContent;
        }
        field(50054; "Document Type"; Option)
        {
            OptionMembers = "Collateral","Document","Others";
            DataClassification = CustomerContent;
        }

        field(50055; "SC Duration"; DateFormula)
        {
            Caption = 'Duration';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                "Maturity Date" := CalcDate("SC Duration", Today);
            end;
        }
        field(50056; "Maturity Date"; Date)
        {
            Caption = 'Maturity Date';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50057; "Maturity Instructions"; Option)
        {
            OptionCaption = ' ,Renew,Post Once';
            OptionMembers = " ","Renew","Post Once";
            Caption = 'Maturity Instructions';
            DataClassification = CustomerContent;
        }
        field(50058; "Savings Account No."; Code[20])
        {
            TableRelation = "Account Banking" where("Member No." = field("Account No."), "Account Category" = const(Savings), Status = const(Active));
            Caption = 'Savings Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50059; "Picture"; Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(50060; "Signature"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50061; "Third Party Access"; Text[150])
        {
            Caption = 'Third Party Nominee';
            DataClassification = CustomerContent;
        }
        field(50062; "Third Party Access ID/Passport"; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(50063; "Terms & Conditions"; Boolean)
        {
            Caption = 'Have Read and understood Terms & Conditions';
            DataClassification = CustomerContent;
        }
        field(50064; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code where(Type = filter("Safe Custody"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50065; "Physical Location"; Text[150])
        {
            DataClassification = CustomerContent;
        }
        field(50066; "Deed Transfer No."; Code[50])
        {
            DataClassification = CustomerContent;
        }
        field(50067; "Value on Completion"; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(50068; "Property Holder"; Text[150])
        {
            DataClassification = CustomerContent;
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
        fieldgroup(DropDown; "No.", "Collateral Name")
        {
        }
    }

    trigger OnDelete()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Loan Security Nos.");
            
        end;
        PassDocumentNo
    end;

    trigger OnModify()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime;

    end;

    trigger OnRename()
    begin
        "Last Modified By" := UserId;
        "Last Modified Date" := CurrentDateTime
    end;

    var
        SalesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        CusMembr: Record Member;
        SecurityRegSetUp: Record "Loan Securities Set-up";
        Text001: Label 'This collateral is blocked thus not avaialable for use.';
        GenSetup: Record "General Set-Up";
        Text003: Label 'The last valuation day is more than %1 hence is invalid';
        Text004: Label 'Last valuation date cannot be greater than today';
        RegMgt: Codeunit "Register Management";
        Temp: Record "User Setup";

    procedure PassDocumentNo()
    begin
        Temp.Get(UserId);
        Temp.TestField("Responsibility Centre");
        Temp.TestField("Global Dimension 1 Code");
        Temp.TestField("Global Dimension 2 Code");
        "Responsibility Center" := Temp."Responsibility Centre";
        "Global Dimension 1 Code" := Temp."Global Dimension 1 Code";
        "Global Dimension 2 Code" := Temp."Global Dimension 2 Code";
        "Captured By" := UserId;
        "Application Date" := CurrentDateTime;

    end;


    procedure CheckRequiredItems()
    begin
        TestField(Remarks);
        case Rec."Document Type" of
            Rec."Document Type"::Collateral:
                begin
                    TestField("Account No.");
                    TestField("Collateral Type");
                    TestField("Collateral Value");
                    TestField("Forced Sale Value");
                    TestField("Last Valuation Date");
                    TestField("Collateral Multiplier");
                    TestField("Collateral Limit");
                    TestField("Registration No.");

                    case "Collateral Type" of
                        "Collateral Type"::"Motor Vehicle":
                            begin
                                TestField("Registration No.");
                                TestField("Engine No.");
                                TestField("Year of Manufacture");
                                TestField("Chasis No.");
                            end;
                    end;
                end;
            Rec."Document Type"::Document:
                begin
                    Rec.TestField("Savings Account No.");
                    Rec.TestField("SC Duration");
                    Rec.TestField("Maturity Date");
                    Rec.TestField("Maturity Instructions");
                    Rec.TestField("Account No.");
                    if Rec."Third Party Access ID/Passport" <> '' then begin
                        Rec.TestField(Picture);
                        Rec.TestField("Third Party Access");
                    end;
                end;
        end;
    end;
}




