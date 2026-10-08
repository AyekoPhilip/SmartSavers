table 50524 "Cheque Schedule"
{
    DataClassification = CustomerContent;
    fields
    {
        field(50009; "No."; Integer)
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        }
        field(50010; "Client Code"; Code[20])
        {
            Caption = 'Client Code';
            DataClassification = CustomerContent;
        }
        field(50011; "Payee"; Text[50])
        {
            Caption = 'Payee';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if Payee <> 'CANCELLED' then
                    Error('You can only enter CANCELLED as payee when entering Cheques manually');
            end;
        }
        field(50012; "Cheque Date"; Date)
        {
            Caption = 'Cheque Date';
            DataClassification = CustomerContent;
        }
        field(50013; "Cheque No."; Code[10])
        {
            Caption = 'Cheque No.';
            DataClassification = CustomerContent;
        }
        field(50014; "Amount"; Decimal)
        {
            Caption = 'Amount';
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

    trigger OnDelete()
    begin
        Error('You cannot Delete Data From this table');
    end;

    trigger OnInsert()
    begin
        StatusPermissions.Reset;
        StatusPermissions.SetRange(StatusPermissions."User ID", UserId);
        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."Function"::"Cheque Schedule");
        if StatusPermissions.Find('-') = false then
            Error('You do not have permissions to insert in the cheque schedule table.');
    end;

    trigger OnModify()
    begin
        StatusPermissions.Reset;
        StatusPermissions.SetRange(StatusPermissions."User ID", UserId);
        StatusPermissions.SetRange(StatusPermissions."Function", StatusPermissions."Function"::"Cheque Schedule");
        if StatusPermissions.Find('-') = false then
            Error('You do not have permissions to insert in the cheque schedule table.');
    end;

    trigger OnRename()
    begin
        Error('You cannot Rename Data in this table');
    end;

    var
        StatusPermissions: Record "Status Change Permissions";
}




