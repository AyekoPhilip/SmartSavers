table 50368 "Fixed Deposit Notification Lis"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "User Type"; Option)
        {
            OptionCaption = 'User,Member';
            OptionMembers = "User","Member";
            Caption = 'User Type';
            DataClassification = CustomerContent;
        }
        field(50010; "User Id"; Code[50])
        {
            TableRelation = IF ("User Type" = CONST(User)) "User Setup";
            Caption = 'User Id';
            DataClassification = CustomerContent;
        }
        field(50011; "Fixed Deposit Type"; Code[20])
        {
            Caption = 'Fixed Deposit Type';
            DataClassification = CustomerContent;
        }
        field(50012; "Notification Type"; Option)
        {
            Description = 'Blank,Email,Notification,SMS';
            OptionCaption = ' ,Email,SMS';
            OptionMembers = " ","Email","Notification","SMS";
            Caption = 'Notification Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Notification Period"; Integer)
        {
            Caption = 'Notification Period(Days)';
            Description = 'How many days before maturing';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "Fixed Deposit Type", "User Type", "User Id")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}




