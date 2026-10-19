table 90005 "Board allowance table"
{
    Caption = 'Board allowance table';
    DataClassification = ToBeClassified;

    fields
    {
        field(50009; "Entry Number"; Integer)
        {
            Caption = 'Entry Number';
            AutoIncrement = true;
        }
        field(50010; "Member Number"; Code[100])
        {
            Caption = 'Member Number';
            TableRelation = Member."No." where("Member Category"= filter('DIRECTOR'|'STAFF'));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF MEMBS.GET("Member Number") THEN begin
                    "Member Name" := MEMBS.Name;
                end;
            end;
        }
        field(50011; "Member Name"; Text[100])
        {
            Caption = 'Member Name';
            Editable = false;
        }
        field(50012; "Payment Date"; Date)
        {
            Caption = 'Payment Date';
        }
        field(50013; "Amount Paid"; Decimal)
        {
            Caption = 'Amount Paid';
        }
        field(50014; "Tax Paid"; Boolean)
        {
            Caption = 'Tax Paid';
            trigger OnValidate()
            begin
                "Tax amount" := 0;
                "Tax amount" := "Amount Paid" * 0.35;
            end;
        }
        field(50015; "Tax amount"; Decimal)
        {
            Caption = 'Tax amount';
            Editable = false;
        }
        field(50016; Paid; Boolean)
        {
            Caption = 'Paid';
        }
        field(50017; "Payment type"; enum BoardAllowancesType)
        {
            Caption = 'Payment type';
        }
        field(50018;"Activity Type"; Enum "Board Activity Type")
        {
            Caption = 'Activity Type';
        }
    }


    keys
    {
        key(PK; "Entry Number")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
    end;

    trigger OnModify()
    begin
      //  TestField(Paid, false);
    end;

    trigger OnRename()
    begin
      //5678  TestField(Paid, false);
    end;


    trigger OnDelete()
    begin
        TestField(Paid, false);
    end;

    var

        MEMBS: Record Member;
}
