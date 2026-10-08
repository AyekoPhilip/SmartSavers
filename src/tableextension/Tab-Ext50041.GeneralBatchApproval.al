tableextension 50041 "General Batch Approval" extends "Gen. Journal Batch"
{
    fields
    {
        modify(Name)
        {
            trigger OnAfterValidate()
            begin
                
            end;
        }
        field(50009; "Payroll period"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Payroll period';
        }
        field(50010; "Payroll start date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Payroll start date';
        }
        field(50011; "User ID"; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'User ID';
            TableRelation = "User Setup";
        
            trigger OnValidate()
            begin
                Temp.Get("User ID");
                Temp.TestField("Responsibility Centre");
                Validate("Responsibility Centre",Temp."Responsibility Centre");
                
            end;
        }
        field(50012; "Responsibility Centre"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Responsibility Centre';
            Editable = false;
            TableRelation = "Responsibility Center";
        
            trigger OnValidate()
            begin
                TestField("User ID",UserId);
            end;
        }
        field(50013; "Approval Status"; Enum "ApprovalStatus")
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Approval Status';
        }
    }
    var
    Temp: Record "User Setup";
}


