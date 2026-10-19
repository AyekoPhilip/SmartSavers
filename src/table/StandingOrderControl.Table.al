table 50383 "Standing Order Control"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "No."; Code[10])
        {
            Editable = false;
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50010; "Document Date"; Date)
        {
            Editable = false;
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(50011; "No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50012; "Transaction Branch"; Code[10])
        {
            Editable = false;
            Caption = 'Transaction Branch';
            DataClassification = CustomerContent;
        }
        field(50013; "Responsibility Center"; Code[20])
        {
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50014; "Status"; Option)
        {
            Editable = false;
            OptionMembers = "Open","Pending","Approved","Rejected","Processed";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50015; "Document Type"; Option)
        {
            OptionMembers = "Open","Pending","Approved","Rejected","Stopped";
            Caption = 'Document Type';
            DataClassification = CustomerContent;
        }
        field(50016; "Standing Order No"; Code[10])
        {
            TableRelation = "Standing Order Header" WHERE("Approval Status" = FILTER(Approved | Stopped));
            Caption = 'Standing Order No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                StandingOrderHeader: Record "Standing Order Header";
                StandingOrderControl: Record "Standing Order Control";
                ExistingAppliactionError: Label 'There is an exiting Pending appliaction for this Standing Order.';
            begin
                StandingOrderControl.Reset;
                StandingOrderControl.SetRange(StandingOrderControl."Standing Order No", "Standing Order No");
                StandingOrderControl.SetRange(StandingOrderControl.Status, StandingOrderControl.Status::Open,
                                              StandingOrderControl.Status::Pending);
                if StandingOrderControl.FindFirst then begin
                    Error(ExistingAppliactionError);
                end;

                if StandingOrderHeader.Get("Standing Order No") then begin
                    "Source Account Type" := StandingOrderHeader."Source Account Type";
                    "Source Account No." := StandingOrderHeader."Source Account No.";
                    "Source Account Name" := StandingOrderHeader."Source Account Name";
                    "Member No." := StandingOrderHeader."Member No.";
                    "ID Number" := StandingOrderHeader."ID Number";
                    "Payroll/Staff No." := StandingOrderHeader."Payroll/Staff No.";
                    "Income Type" := StandingOrderHeader."Income Type";
                    "Allow Partial Deduction" := StandingOrderHeader."Allow Partial Deduction";
                    Amount := StandingOrderHeader.Amount;
                    "Effective Date" := StandingOrderHeader."Effective/Start Date";
                    Frequency := StandingOrderHeader."Frequency (Months)";
                    "End Date" := StandingOrderHeader."End Date";
                end;
            end;
        }
        field(50017; "Source Account Type"; Enum "CreditAccountTypes")
        {
            Editable = false;
            Caption = 'Source Account Type';
            DataClassification = CustomerContent;
        }
        field(50018; "Source Account No."; Code[20])
        {
            Editable = false;
            Caption = 'Source Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                StandingOrderHeader: Record "Standing Order Header";
            begin
            end;
        }
        field(50019; "Source Account Name"; Text[80])
        {
            Editable = false;
            Caption = 'Source Account Name';
            DataClassification = CustomerContent;
        }
        field(50020; "Member No."; Code[10])
        {
            Editable = false;
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50021; "ID Number"; Code[20])
        {
            Editable = false;
            Caption = 'ID Number';
            DataClassification = CustomerContent;
        }
        field(50022; "Payroll/Staff No."; Code[20])
        {
            Editable = false;
            Caption = 'Payroll/Staff No.';
            DataClassification = CustomerContent;
        }
        field(50023; "Description"; Text[50])
        {
            Description = 'LookUp to Standing Orders Description Table';
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(50024; "Allow Partial Deduction"; Boolean)
        {
            Editable = false;
            Caption = 'Allow Partial Deduction';
            DataClassification = CustomerContent;
        }
        field(50025; "Income Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Periodic,Salary,Pension,Milk,Tea,Coffee';
            OptionMembers = "Periodic","Salary","Pension","Milk","Tea","Coffee";
            Caption = 'Income Type';
            DataClassification = CustomerContent;
        }
        field(50026; "Amount"; Decimal)
        {
            Editable = false;
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50027; "Deduction Type"; Option)
        {
            Editable = false;
            OptionCaption = 'Partial,Full';
            OptionMembers = "Partial","Full";
            Caption = 'Deduction Type';
            DataClassification = CustomerContent;
        }
        field(50028; "Effective Date"; Date)
        {
            Editable = false;
            Caption = 'Effective Date';
            DataClassification = CustomerContent;
        }
        field(50029; "Frequency"; DateFormula)
        {
            Editable = false;
            Caption = 'Frequency';
            DataClassification = CustomerContent;
        }
        field(50030; "End Date"; Date)
        {
            Editable = false;
            Caption = 'End Date';
            DataClassification = CustomerContent;
        }
        field(50031; "Created By"; Code[50])
        {
            Editable = false;
            Caption = 'Created By';
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
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            SeriesSetup.Get;
            SeriesSetup.TestField(SeriesSetup."Standing Order Control Nos.");
            
        end;

        "Document Date" := Today;
        "Created By" := UserId;
    end;

    var
        SeriesSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
}




