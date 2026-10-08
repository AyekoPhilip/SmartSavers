table 50426 "Cheque Book Application"
{
    DataClassification = CustomerContent;
    /* DrillDownPageID = 52018532;
    LookupPageID = 52018532; */

    fields
    {
        field(50009; "No."; Code[10])
        {
            Caption = 'No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                
            end;
        }
        field(50010; "Account No."; Code[20])
        {
            TableRelation = "Account Banking"."No.";
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Vend.Reset;
                Vend.SetRange(Vend."No.", "Account No.");
                //Vend.SETFILTER(Vend."Account Type",'502|504|509');
                if Vend.Find('-') then begin
                    Vend.TestField(Vend."Member No.");
                    //"Account No.":=Vend."No.";
                    //Name:=Vend.Name;
                    //"ID No.":= Vend."ID No.";//Vend."Identification No.";
                    //"Staff No.":=Vend."Payroll/Staff No.";
                    //"Member No.":=Vend."Member No.";
                    //"Cheque Account No.":='0'+"Member No."+'0129';

                    //for existing cheque book holders
                    Translation.Reset;
                    Translation.SetRange(Translation."Member No", Vend."Member No.");
                    if Translation.Find('-') then begin
                        "Cheque Account No." := Translation."Cheque Account No";
                        "Translation Code" := Translation.Code;
                    end else begin

                        //for new cheque book applicants
                        Translation.Reset;
                        Translation.SetRange(Translation.Used, false);
                        if Translation.Find('-') then begin
                            "Cheque Account No." := '0' + Translation.Code + '0129';
                            "Translation Code" := Translation.Code;
                            Translation."Cheque Account No" := '0' + Translation.Code + '0129';
                            Translation."Member No" := Vend."Member No.";
                            Translation."Member Name" := Vend.Name;
                            Translation.Used := true;
                            Translation.Modify;
                        end;


                    end;
                end else begin
                    Error('Member no. not found');
                end;

                /*
                IF Vend.GET("Account No.")  THEN BEGIN
                IF Vend."ChqAcount Number" = '' THEN BEGIN
                IF acctypes.GET(Vend."Account Type") THEN BEGIN
                //LASTNUMBER:=acctypes.ChqNumbers;
                acctypes.ChqNumbers:=INCSTR(acctypes.ChqNumbers);
                acctypes.MODIFY;
                END;
                Vend."ChqAcount Number":=LASTNUMBER;
                IF "Cheque Account No." = '' THEN BEGIN
                "Cheque Account No.":=Vend."ChqAcount Number";
                MODIFY;
                END;
                Vend.MODIFY;
                END;
                END;
                 */

            end;
        }
        field(50011; "Name"; Text[50])
        {
            Caption = 'Name';
            DataClassification = CustomerContent;
        }
        field(50012; "ID No."; Code[20])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        }
        field(50013; "Application Date"; Date)
        {
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50014; "Cheque Account No."; Code[20])
        {
            Caption = 'Cheque Account No.';
            DataClassification = CustomerContent;
        }
        field(50015; "Staff No."; Code[20])
        {
            Caption = 'Staff No.';
            DataClassification = CustomerContent;
        }
        field(50016; "Export Format"; Code[10])
        {
            Caption = 'Export Format';
            DataClassification = CustomerContent;
        }
        field(50017; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50018; "Member No."; Code[10])
        {
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        }
        field(50019; "Responsibility Centre"; Code[20])
        {
            TableRelation = "Responsibility Center BR";
            Caption = 'Responsibility Centre';
            DataClassification = CustomerContent;
        }
        field(50020; "Begining Cheque No."; Code[60])
        {
            Caption = 'Begining Cheque No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                /*ChequeSetUp.RESET;
                ChequeSetUp.SETRANGE(ChequeSetUp."Cheque Code","Cheque Book Type");
                IF ChequeSetUp.FIND('-') THEN BEGIN
                
                EVALUATE(BeginNo,"Begining Cheque No.");
                EVALUATE(NoofLF,ChequeSetUp."Number Of Leaf");
                "End Cheque No.":=FORMAT(BeginNo+NoofLF);
                END;
                */

                Chqreg.Reset;
                Chqreg.SetRange("Cheque No.", "Begining Cheque No.");
                if Chqreg.Find('-') then
                    Error('That cheque range has been used');

            end;
        }
        field(50021; "End Cheque No."; Code[60])
        {
            Caption = 'End Cheque No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                Chqreg.Reset;
                Chqreg.SetRange("Cheque No.", "End Cheque No.");
                if Chqreg.Find('-') then
                    Error('That cheque range has been used');
            end;
        }
        field(50022; "Application Exported"; Boolean)
        {
            Caption = 'Application Exported';
            DataClassification = CustomerContent;
        }
        field(50023; "Cheque Register Generated"; Boolean)
        {
            Editable = false;
            Caption = 'Cheque Register Generated';
            DataClassification = CustomerContent;
        }
        field(50024; "Select"; Boolean)
        {
            Caption = 'Select';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Cheque Book charges Posted" = false then
                    Error('Please Post Cheque book charges before exporting');
            end;
        }
        field(50025; "Cheque Book charges Posted"; Boolean)
        {
            Editable = false;
            Caption = 'Cheque Book charges Posted';
            DataClassification = CustomerContent;
        }
        field(50026; "Cheque Book Type"; Code[10])
        {
            TableRelation = "Cheque Set Up";
            Caption = 'Cheque Book Type';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ChApp.Reset;
                ChApp.SetRange(ChApp."Account No.", "Account No.");
                ChApp.SetRange(ChApp.Status, ChApp.Status::Approved);
                if ChApp.Find('+') then begin
                    "Begining Cheque No." := IncStr(ChApp."End Cheque No.");

                end;


                //VALIDATE("Begining Cheque No.");
            end;
        }
        field(50027; "Status"; Option)
        {
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = "Open","Pending Approval","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50028; "Last check"; Code[30])
        {
            CalcFormula = Max("Cheques Register"."Cheque No." WHERE("Account No." = FIELD("Account No.")));
            FieldClass = FlowField;
            Caption = 'Last check';
        }
        field(50029; "Transaction Type"; Code[20])
        {
            TableRelation = "Transaction Types".Code WHERE(Type = CONST("Cheque Application"));
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
        }
        field(50030; "Translation Code"; Code[20])
        {
            Caption = 'Translation Code';
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
            SalesSetup.Get;
            SalesSetup.TestField(SalesSetup."Cheque Application Nos");
            
        end;

        "Application Date" := Today;


        UserSetup.Reset;
        UserSetup.SetRange(UserSetup."User ID", UserId);
        if UserSetup.Find('-') then begin
            UserSetup.TestField(UserSetup."Responsibility Centre");
            "Responsibility Centre" := UserSetup."Responsibility Centre";
        end;
    end;

    trigger OnModify()
    begin

        // IF Status=Status::Approved THEN BEGIN
        if "Cheque Register Generated" = true then
            Error('Cheque register has already been generated you cannot make modifications.');
        //END;
        //}
    end;

    var
        Vend: Record "Account Banking";
        Noseriesmgt: Codeunit "No. Series";
        SalesSetup: Record "Banking No. Setup";
        ChApp: Record "Cheque Book Application";
        UserSetup: Record "User Setup";
        Chqreg: Record "Cheques Register";
        Translation: Record "Data Translation";
}




