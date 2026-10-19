table 50449 "Teller Transheader"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52140544;
    LookupPageID = 52140544; */

    fields
    {
        field(50009; "No"; Code[20])
        {
            Caption = 'No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*
                IF No <> xRec.No THEN BEGIN
                  NoSetup.GET();
                  NoSeriesMgt.TestManual(NoSetup."Teller Bulk Trans Nos.");
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(50010; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50011; "Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Posted';
            DataClassification = CustomerContent;
        }
        field(50012; "Posted By"; Code[20])
        {
            Editable = false;
            Caption = 'Posted By';
            DataClassification = CustomerContent;
        }
        field(50013; "Date Entered"; Date)
        {
            Caption = 'Date Entered';
            DataClassification = CustomerContent;
        }
        field(50014; "Entered By"; Text[20])
        {
            Caption = 'Entered By';
            DataClassification = CustomerContent;
        }
        field(50015; "Remarks"; Text[150])
        {
            Caption = 'Remarks';
            DataClassification = CustomerContent;
        }
        field(50016; "Date Filter"; Date)
        {
            FieldClass = FlowFilter;
            Caption = 'Date Filter';
        }
        field(50017; "Time Entered"; Time)
        {
            Caption = 'Time Entered';
            DataClassification = CustomerContent;
        }
        field(50018; "Posting date"; Date)
        {
            Caption = 'Posting date';
            DataClassification = CustomerContent;
        }
        field(50019; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = "G/L Account","Customer","Vendor","Bank Account","Fixed Asset";
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50020; "Account No"; Code[30])
        {
            TableRelation = "Account Banking"."No.";
            Caption = 'Account No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*  BANKACC.RESET;
                  BANKACC.SETRANGE(BANKACC."No.","Account No");
                  BANKACC.SETRANGE(BANKACC.CashierID,USERID );
                  IF BANKACC.FIND('-') THEN BEGIN
                  "Account Name":=BANKACC.Name;
                  END ELSE
                ERROR('You need a till for this transaction')
                */

            end;
        }
        field(50021; "Document No"; Code[20])
        {
            Caption = 'Document No';
            DataClassification = CustomerContent;
        }
        field(50022; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(50023; "Account Name"; Code[50])
        {
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50024; "Employer Code"; Code[30])
        {
            Caption = 'Employer Code';
            DataClassification = CustomerContent;
        }
        field(50025; "Document Date"; Date)
        {
            Caption = 'Document Date';
            DataClassification = CustomerContent;
        }
        field(50026; "Total Amount"; Decimal)
        {
            CalcFormula = Sum("Teller Translines".Amount WHERE("Teller Transheader No" = FIELD(No)));
            FieldClass = FlowField;
            Caption = 'Total Amount';
        }
        field(50027; "Status"; Option)
        {
            OptionCaption = 'Open,Pending,Approved,Rejected';
            OptionMembers = "Open","Pending","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50028; "Scheduled Amount"; Decimal)
        {
            Caption = 'Scheduled Amount';
            DataClassification = CustomerContent;
        }
        field(50029; "Transacted by"; Code[50])
        {
            Caption = 'Transacted by';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key("Key1"; "No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //IF Posted = TRUE THEN
        //ERROR('You cannot delete a Posted Check Off');
        /*
        IF "Entered By" <> UPPERCASE(USERID) THEN
        ERROR('Cannot delete a transaction being processed by %1',"Entered By");
                   */

    end;

    trigger OnInsert()
    begin
        /*
        IF No = '' THEN BEGIN
        NoSetup.GET();
        NoSetup.TESTFIELD(NoSetup."Teller Bulk Trans Nos.");
        NoSeriesMgt.InitSeries(NoSetup."Teller Bulk Trans Nos.",xRec."No. Series",0D,No,"No. Series");
        END;
        
         "Document Date":=TODAY;
         "Document No":=No;
         "Posting date":=TODAY;
         "Entered By":=USERID;
        "Account Type":="Account Type"::"Bank Account";
        "Time Entered":=TIME;
        */

    end;

    trigger OnModify()
    begin
        //IF Posted = TRUE THEN
        //ERROR('You cannot modify a Posted Check Off');
        /*
      //Cyrus
      IF "Entered By" <> UPPERCASE(USERID) THEN
      ERROR('Cannot modify a transaction being processed by %1',"Entered By");
      */

    end;

    trigger OnRename()
    begin
        //IF Posted = TRUE THEN
        //ERROR('You cannot rename a Posted Check Off');
        /*
     IF "Entered By" <> UPPERCASE(USERID) THEN
     ERROR('Cannot rename a transaction being processed by %1',"Entered By");
         */

    end;
}




