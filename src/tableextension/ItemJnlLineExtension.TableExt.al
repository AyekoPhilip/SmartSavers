tableextension 50004 "ItemJnlLineExtension" extends "Item Journal Line"
{
    fields
    {
        field(50009; "Narration"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Narration';
        }
        field(50010; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            TableRelation = "Hr Employees"."No.";
        
            trigger OnValidate()
            begin
                if ObjtEmp.Get("Staff No.") then
                    "Staff Name" := ObjtEmp.Name

            end;
        }
        field(50011; "Staff Name"; Text[150])
        {
            Caption = 'Staff Name';
            Editable = false;
        }
        field(50012; "Leave Approval Date"; Date)
        {
            Caption = 'Leave Approval Date';
        }
        field(50013; "No. of Days"; Decimal)
        {
            Caption = 'No. of Days';
        }
        field(50014; "Leave Type"; Code[10])
        {
            Caption = 'Leave Type';
            TableRelation = "Hr Leave Type".Code;
        }
        field(50015; "Leave Recalled No."; Code[10])
        {
            Caption = 'Leave Recalled No.';
        }
        field(50016; "Leave Period Start Date"; Date)
        {
            Caption = 'Leave Period Start Date';
        }
        field(50017; "Leave Period End Date"; Date)
        {
            Caption = 'Leave Period End Date';
        }
        field(50018; "Positive Transaction Type"; Option)
        {
            Caption = 'Positive Transaction Type';
            OptionMembers = " ","Leave Allocation","Leave Recall","Overtime";
        }
        field(50019; "Negative Transaction Type"; Option)
        {
            Caption = 'Negative Transaction Type';
            OptionMembers = " ","Leave Taken","Leave Forfeited";
        }
        field(50020; "Leave Application No."; Code[50])
        {
            Caption = 'Leave Application No.';
            TableRelation = "Hr Leave Mgt."."No.";
        }
        field(50021; "Leave Calendar Code"; Code[20])
        {
            Caption = 'Leave Calendar Code';
            TableRelation = "Hr Leave Calendar"."Calendar Code";
        }
    }

    procedure Post()
    begin
        Codeunit.Run(Codeunit::"Item Jnl.-Post", Rec);
    end;

    var
        ObjtEmp: Record "Hr Employees";
}


