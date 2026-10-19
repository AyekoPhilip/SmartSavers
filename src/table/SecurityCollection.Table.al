table 50474 "Security Collection"
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
                TestNoSeries();
            end;
        }
        field(50010; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
            DataClassification = CustomerContent;
        }
        field(50011; "Account No."; Code[20])
        {
            TableRelation = Member;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Account.Reset();
                Account.SetRange("Member No.",Rec."Account No.");
                Account.SetRange("Account Category",Account."Account Category"::Savings);
                if Account.FindFirst() then begin
                    Rec."Savings Account No.":=Account."No.";
                end;


            end;
        }
        field(50012; "Account Name"; Text[100])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50013; "Collateral Type"; Enum "CollateralType")
        {
            Editable = false;
            Caption = 'Collateral Type';
            DataClassification = CustomerContent;
        }
        field(50014; "Collateral"; Code[10])
        {
            Editable = false;
            TableRelation = "Loan Securities Set-up".Code WHERE(Type = FIELD("Collateral Type"));
            Caption = 'Collateral';
            DataClassification = CustomerContent;
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
            Editable = false;
            Caption = 'Collateral Value';
            DataClassification = CustomerContent;
        }
        field(50018; "Collateral Limit"; Decimal)
        {
            Editable = false;
            Caption = 'Collateral Limit';
            DataClassification = CustomerContent;
        }
        field(50019; "Approval Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected,Deffered,Posted';
            OptionMembers = "Open","Pending Approval","Approved","Rejected","Deffered","Posted";
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
            Editable = false;
            Caption = 'Last Valuation Date';
            DataClassification = CustomerContent;
        }
        field(50022; "Forced Sale Value"; Decimal)
        {
            Editable = false;
            Caption = 'Forced Sale Value';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Text001: Label 'Forced sale value cannot be more than collateral limit';
            begin
            end;
        }
        field(50023; "Collateral Perfected"; Boolean)
        {
            Editable = false;
            Caption = 'Collateral Perfected';
            DataClassification = CustomerContent;
        }
        field(50024; "Next Valuation Date"; Date)
        {
            Editable = false;
            Caption = 'Next Valuation Date';
            DataClassification = CustomerContent;
        }
        field(50025; "Remarks"; Text[50])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50026; "Collateral Register No."; Code[20])
        {
            TableRelation = if ("Document Type"=const(Document)) "Collateral Register"."No." where("Approval Status" = const(Posted), "Inward/Outward" = const("In-Store"),"Document Type"=const(Document),"Account No."=field("Account No."))
        else if ("Document Type"=const(Collateral)) "Collateral Register"."No." where("Approval Status" = filter(Approved| Posted), "Inward/Outward" = const("In-Store"),"Document Type"=const(Collateral),"Account No."=field("Account No."));
            Caption = 'Collateral Register No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if CollSec.Get("Collateral Register No.") then begin
                    LoanGua.Reset;
                    LoanGua.SetRange("Collateral Reg. No.", "Collateral Register No.");
                    if LoanGua.Find('-') then begin
                        LoanGua.CalcFields("Outstanding Balance");
                        if LoanGua."Outstanding Balance" > 0 then
                            Error(Text006, LoanGua."Product Type");
                    end;
                    "Account Name" := CollSec."Account Name";
                    "Account No." := CollSec."Account No.";
                    Collateral := CollSec.Collateral;
                    "Collateral Limit" := CollSec."Collateral Limit";
                    "Collateral Multiplier" := CollSec."Collateral Multiplier";
                    "Collateral Name" := CollSec."Collateral Name";
                    "Collateral Type" := CollSec."Collateral Type";
                    "Collateral Value" := CollSec."Collateral Value";
                    "Forced Sale Value" := CollSec."Forced Sale Value";
                    "Inward/Outward" := CollSec."Inward/Outward";
                    "Last Valuation Date" := CollSec."Last Valuation Date";
                    "Next Valuation Date" := CollSec."Next Valuation Date";
                end;
            end;
        }
        field(50027; "Responsibility Center"; Code[10])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Center';
        }
        field(50028; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code")
            end;
        }
        field(50029; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        
            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
        }
        field(50030; "Captured By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Captured By';
        }
        field(50031; "Application Date"; Date)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Application Date';
        }
        field(50032; "Last Modified Date"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Last Modified Date';
        }
        field(50033; "Date Posted"; DateTime)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Date Posted';
        }
        field(50034; "Posted By"; Code[100])
        {
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = "User Setup"."User ID";
            Caption = 'Posted By';
        }
         field(50035; "Document Type"; Option)
        {
            OptionMembers = "Collateral","Document","Others";
            DataClassification = CustomerContent;
        }
         field(50036; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code where(Type = filter(Collection));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50037; "Savings Account No."; Code[20])
        {
            TableRelation = "Account Banking" where("Member No." = field("Account No."), "Account Category" = const(Savings), Status = const(Active));
            Caption = 'Savings Account No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(50038; "Operation Type"; Option)
        {
            OptionMembers = " ","Retrieval","Collection";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
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

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Loan Security Nos.");
            "No. Series" := SalesSetup."Loan Security Collection Nos";
            if NoSeriesMgt.AreRelated(SalesSetup."Loan Security Collection Nos" , xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series");
            PassDocumentNo
        end;
    end;

    local procedure TestNoSeries()
    var
        RecRefHeader: Record "Security Collection";
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeTestNoSeries(Rec, xRec, IsHandled);
        if IsHandled then
            exit;

        if "No." <> xRec."No." then
            if not RecRefHeader.Get(Rec."No.") then begin
                SalesSetup .Get();
                NoSeriesMgt.TestManual(SalesSetup."Loan Security Collection Nos");
                "No. Series" := '';
            end;
    end;

[IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeries(var RecRef: Record "Security Collection"; xRecRef: Record "Security Collection"; var IsHandled: Boolean)
    begin
    end;



    var
        SalesSetup: Record "Credit Nos. Series";
        NoSeriesMgt: Codeunit "No. Series";
        CollSec: Record "Collateral Register";
        LoanGua: Record "Guarantor & Security Posted";
        Text006: Label 'The loan which was guaranteed using the collateral has a balance of %1';
        Account: Record "Account Banking";

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::"Loan Application", "No.", FieldNumber, ShortcutDimCode);
        Modify;
    end;

    local procedure PassDocumentNo()
    var
        ExemptionsApprvl: Record "User Setup";
    begin
        ExemptionsApprvl.Get(UserId);
        ExemptionsApprvl.TestField("Responsibility Centre");
        ExemptionsApprvl.TestField("Global Dimension 1 Code");
        ExemptionsApprvl.TestField("Global Dimension 2 Code");
        "Responsibility Center" := ExemptionsApprvl."Responsibility Centre";
        "Global Dimension 1 Code" := ExemptionsApprvl."Global Dimension 1 Code";
        "Global Dimension 2 Code" := ExemptionsApprvl."Global Dimension 2 Code";
        "Captured By" := UserId;
        "Application Date" := Today;
    end;
}




