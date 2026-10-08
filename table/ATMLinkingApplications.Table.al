table 50473 "ATM Linking Applications"
{
    DrillDownPageID = "Application Picture";
    LookupPageID = "Application Picture";
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
                
            end;
        }
        field(50010; "Account No"; Code[20])
        {
            TableRelation = "Account Banking"."No." WHERE("Account Category" = CONST(Savings));
            Caption = 'Account No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

                ATMApplications.SetRange(ATMApplications."Account No", "Account No");
                ATMApplications.SetRange(ATMApplications."ATM Linked", true);
                if ATMApplications.Find('-') then begin
                    repeat
                        //MESSAGE(ATMApplications."No.");
                        ATMCount += 1;
                    until ATMApplications.Next = 0;
                end;
                if ATMCount > 0 then;
                //ERROR('The member has an existing linking application');
                /*
                ATMApplications.RESET;
                ATMApplications.SETRANGE(ATMApplications."Account No","Account No");
                ATMApplications.SETRANGE(ATMApplications."ATM Delinked",FALSE);
                IF ATMApplications.FIND('-') THEN
                  BEGIN
                    REPEAT
                      IF ATMApplications."ATM Charges Applied"=FALSE
                        THEN ERROR('This Account has an active ATM application');
                      UNTIL ATMApplications.NEXT=0;
                    END;
                TESTFIELD("Card Type");
                UserSetup.GET(USERID);
                SavingsAccounts.RESET;
                SavingsAccounts.SETRANGE(SavingsAccounts."No.","Account No");
                IF SavingsAccounts.FIND('-') THEN
                  BEGIN
                    Members.RESET;
                    Members.SETRANGE(Members."No.",SavingsAccounts."Member No.");
                    IF Members.FIND('-') THEN
                      BEGIN
                        "Branch Code":=Members."Global Dimension 2 Code";
                        "Shortcut Dimension 1 Code":=UserSetup."Global Dimension 1 Code";//Members."Global Dimension 1 Code";
                        "Shortcut Dimension 2 Code":=UserSetup."Global Dimension 2 Code";//Members."Global Dimension 2 Code";
                        "Account Name":=Members.Name;
                        "Customer ID":=Members."ID No.";
                        "Phone No.":=Members."Phone No.";
                        Address:=Members."Current Address";
                        END ELSE
                        BEGIN
                         "Branch Code":='';
                        "Shortcut Dimension 1 Code":='';
                        "Shortcut Dimension 2 Code":='';
                        "Account Name":='';
                        "Customer ID":='';
                        "Phone No.":='';
                         Address:='';
                          END;
                
                          AvailableBalance:=0;
                          MinBalance:=0;
                          TChargeAmount:=0;
                          IF Account.GET(SavingsAccounts."No.") THEN
                            BEGIN
                              Account.CALCFIELDS(Account.Balance,Account."Uncleared Cheques",Account."Authorised Over Draft",Account."Balance (LCY)");
                              ProdType.RESET;
                              ProdType.SETRANGE(ProdType."Product ID",Account."Product Type");
                              IF ProdType.FIND('-') THEN
                              BEGIN
                              MinBalance:=ProdType."Minimum Balance";
                              AvailableBalance:=(Account."Balance (LCY)"+Account."Authorised Over Draft") - (MinBalance+Account."Uncleared Cheques");
                              END;
                            END;
                
                          GenSetup.GET;
                          ChargeAmount:=0;
                    ATMCardTypes.RESET;
                    ATMCardTypes.SETRANGE(ATMCardTypes."Application Charge Code","Card Type");
                    IF ATMCardTypes.FIND('-') THEN
                      BEGIN
                          TransType.RESET;
                          TransType.SETRANGE(TransType.Code,ATMCardTypes.Code);//TransType.Type::"ATM Applications");
                          IF TransType.FIND('-') THEN
                            BEGIN
                                ChargeAmount:=0;
                                TransactionCharges.RESET;
                                TransactionCharges.SETRANGE(TransactionCharges."Transaction Type",TransType.Code);
                                IF TransactionCharges.FIND('-') THEN
                                  BEGIN
                                    //MESSAGE('here');
                                      REPEAT
                                        ChargeAmount:=0;
                                      IF (TransactionCharges."Transaction Charge Category"=TransactionCharges."Transaction Charge Category"::Normal) OR
                                      (TransactionCharges."Transaction Charge Category"=TransactionCharges."Transaction Charge Category"::"Stamp Duty") THEN
                                      BEGIN
                                          IF TransactionCharges."Charge Type"=TransactionCharges."Charge Type"::"% of Amount" = TRUE THEN
                                          ChargeAmount:=TransactionCharges."Charge Amount"//(TransType.Amount*TransactionCharges."Percentage of Amount")*0.01
                                          ELSE ChargeAmount:=TransactionCharges."Charge Amount";
                
                                          TChargeAmount:=ChargeAmount;
                
                                          IF TransactionCharges."Transaction Charge Category"<>TransactionCharges."Transaction Charge Category"::"Stamp Duty" THEN
                                            BEGIN
                
                                          TChargeAmount:=TChargeAmount+(ChargeAmount*GenSetup."Excise Duty (%)")*0.01;;
                                          END;
                                      END;
                                UNTIL TransactionCharges.NEXT = 0;
                
                              END;
                              END;
                              END;
                              END;
                              IF AvailableBalance<ChargeAmount THEN ERROR(ErrRejectCard,ChargeAmount);
                */

            end;
        }
        field(50011; "Branch Code"; Code[20])
        {
            Editable = false;
            Caption = 'Branch Code';
            DataClassification = CustomerContent;
        }
        field(50012; "Account Type"; Option)
        {
            OptionCaption = 'Savings,Current';
            OptionMembers = "Savings","Current";
            Caption = 'Account Type';
            DataClassification = CustomerContent;
        }
        field(50013; "Account Name"; Text[50])
        {
            Editable = false;
            Caption = 'Account Name';
            DataClassification = CustomerContent;
        }
        field(50014; "Address"; Text[35])
        {
            Editable = false;
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(50015; "Customer ID"; Code[11])
        {
            Editable = true;
            Caption = 'Customer ID';
            DataClassification = CustomerContent;
        }
        field(50016; "Relation Indicator"; Option)
        {
            OptionCaption = 'Primary,Suplimentary';
            OptionMembers = "Primary","Suplimentary";
            Caption = 'Relation Indicator';
            DataClassification = CustomerContent;
        }
        field(50017; "Card Type"; Code[10])
        {
            TableRelation = "ATM Card Types".Code;
            Caption = 'Card Type';
            DataClassification = CustomerContent;
        }
        field(50018; "Request Type"; Option)
        {
            OptionCaption = 'New,Replacement,Re-Pin';
            OptionMembers = "New","Replacement","Re-Pin","Supplementary";
            Caption = 'Request Type';
            DataClassification = CustomerContent;
        }
        field(50019; "Application Date"; Date)
        {
            Editable = false;
            Caption = 'Application Date';
            DataClassification = CustomerContent;
        }
        field(50020; "Card No"; Code[30])
        {
            Caption = 'Card No';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                GeneralSetUp.Get();
                if StrLen("Card No") <> GeneralSetUp."ATM Card No Characters" then
                    Error('ATM Card No %1 MUST be equal to %2 characters.', "Card No", GeneralSetUp."ATM Card No Characters");
                TestField("Account No");
                ATMLinkingApplications.Reset;
                ATMLinkingApplications.SetRange("Card No", "Card No");
                if ATMLinkingApplications.Find('-') then begin
                    Error('This card is already linked to ' + ATMLinkingApplications."Account No");
                end;

                //send sms
                SavingsACC.Reset;
                SavingsACC.SetRange("No.", "Account No");
                if SavingsACC.Find('-') then begin
                    //    SendSMS.SendSms(SourceType::"ATM Collection",SavingsACC."Mobile Phone No",Txt004,"No.","Account No",FALSE);
                end;
            end;
        }
        field(50021; "Date Issued"; Date)
        {
            Editable = false;
            Caption = 'Date Issued';
            DataClassification = CustomerContent;
        }
        field(50022; "Limit"; Decimal)
        {
            Caption = 'Limit';
            DataClassification = CustomerContent;
        }
        field(50023; "Terms Read and Understood"; Boolean)
        {
            Caption = 'Terms Read and Understood';
            DataClassification = CustomerContent;
        }
        field(50024; "Card Issued"; Boolean)
        {
            Editable = false;
            Caption = 'Card Issued';
            DataClassification = CustomerContent;
        }
        field(50025; "Form No"; Code[30])
        {
            Caption = 'Form No';
            DataClassification = CustomerContent;
        }
        field(50026; "Sent To External File"; Option)
        {
            OptionMembers = "No","Yes";
            Caption = 'Sent To External File';
            DataClassification = CustomerContent;
        }
        field(50027; "Card Status"; Option)
        {
            Editable = false;
            OptionMembers = "Pending","Active","Frozen";
            Caption = 'Card Status';
            DataClassification = CustomerContent;
        }
        field(50028; "Date Activated"; Date)
        {
            Editable = false;
            Caption = 'Date Activated';
            DataClassification = CustomerContent;
        }
        field(50029; "Date Frozen"; Date)
        {
            Editable = false;
            Caption = 'Date Frozen';
            DataClassification = CustomerContent;
        }
        field(50030; "Replacement For Card No"; Code[20])
        {
            Caption = 'Replacement For Card No';
            DataClassification = CustomerContent;
        }
        field(50031; "Phone No."; Code[20])
        {
            Caption = 'Phone No.';
            DataClassification = CustomerContent;
        }
        field(50032; "No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'No. Series';
            DataClassification = CustomerContent;
        }
        field(50033; "Collected"; Boolean)
        {
            Editable = false;
            Caption = 'Collected';
            DataClassification = CustomerContent;
        }
        field(50034; "Application Approved"; Boolean)
        {
            Editable = false;
            Caption = 'Application Approved';
            DataClassification = CustomerContent;
        }
        field(50035; "Date Collected"; Date)
        {
            Editable = false;
            Caption = 'Date Collected';
            DataClassification = CustomerContent;
        }
        field(50036; "Card Issued By"; Code[20])
        {
            Editable = false;
            Caption = 'Card Issued By';
            DataClassification = CustomerContent;
        }
        field(50037; "Approval Date"; Date)
        {
            Editable = false;
            Caption = 'Approval Date';
            DataClassification = CustomerContent;
        }
        field(50038; "Status"; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Approved,Rejected';
            OptionMembers = "Open","Pending Approval","Approved","Rejected";
            Caption = 'Status';
            DataClassification = CustomerContent;
        }
        field(50039; "Card Expiry Date"; Date)
        {
            Editable = false;
            Caption = 'Card Expiry Date';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                if "Card Expiry Date" < Today then Error('This card has already expired');
            end;
        }
        field(50040; "Posted By."; Code[80])
        {
            Editable = false;
            TableRelation = "User Setup";
            Caption = 'Posted By.';
            DataClassification = CustomerContent;
        }
        field(50041; "Responsibility Center"; Code[10])
        {
            Editable = false;
            TableRelation = "Responsibility Center BR".Code;
            Caption = 'Responsibility Center';
            DataClassification = CustomerContent;
        }
        field(50042; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
            DataClassification = CustomerContent;
        }
        field(50043; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
            DataClassification = CustomerContent;
        }
        field(50044; "Card Issued Date"; Date)
        {
            Editable = false;
            Caption = 'Card Issued Date';
            DataClassification = CustomerContent;
        }
        field(50045; "PIN Issued Date"; Date)
        {
            Editable = false;
            Caption = 'PIN Issued Date';
            DataClassification = CustomerContent;
        }
        field(50046; "PIN Issued By"; Code[20])
        {
            Editable = false;
            Caption = 'PIN Issued By';
            DataClassification = CustomerContent;
        }
        field(50047; "Linked Date"; Date)
        {
            Editable = false;
            Caption = 'Linked Date';
            DataClassification = CustomerContent;
        }
        field(50048; "ATM Linked"; Boolean)
        {
            Editable = false;
            Caption = 'ATM Linked';
            DataClassification = CustomerContent;
        }
        field(50049; "ATM Charges Applied"; Boolean)
        {
            Caption = 'ATM Charges Applied';
            DataClassification = CustomerContent;
        }
        field(50050; "ATM Charged Date"; Date)
        {
            Caption = 'ATM Charged Date';
            DataClassification = CustomerContent;
        }
        field(50051; "PIN Issued"; Boolean)
        {
            Editable = false;
            Caption = 'PIN Issued';
            DataClassification = CustomerContent;
        }
        field(50052; "Linked By"; Code[50])
        {
            Editable = false;
            Caption = 'Linked By';
            DataClassification = CustomerContent;
        }
        field(50053; "Delinked By"; Code[20])
        {
            Editable = false;
            Caption = 'Delinked By';
            DataClassification = CustomerContent;
        }
        field(50054; "ATM Delinked"; Boolean)
        {
            Editable = false;
            Caption = 'ATM Delinked';
            DataClassification = CustomerContent;
        }
        field(50055; "ATM Delinked Date"; Date)
        {
            Editable = false;
            Caption = 'ATM Delinked Date';
            DataClassification = CustomerContent;
        }
        field(50056; "ATM Application No."; Code[20])
        {
            TableRelation = "ATM Applications"."No." WHERE("Account No" = FIELD("Account No"));
            Caption = 'ATM Application No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                ATMApp.Get("ATM Application No.");
                if ATMApp."ATM Charges Applied" <> true then
                    Error('Kindly Charge the ATM Fee.');
                ATMApplications.SetRange(ATMApplications."ATM Application No.", "ATM Application No.");
                if ATMApplications.Find('-') then begin
                    repeat
                        ATMCount += 1;
                    until ATMApplications.Next = 0;
                end;

                if ATMCount > 0 then
                    "Branch Code" := ATMApp."Branch Code";
                "Account Type" := ATMApp."Account Type";
                "Account Name" := ATMApp."Account Name";
                Address := ATMApp.Address;
                "Customer ID" := ATMApp."Customer ID";
                "Relation Indicator" := ATMApp."Relation Indicator";
                "Card Type" := ATMApp."Card Type";
                "Request Type" := ATMApp."Request Type";
                "Application Date" := ATMApp."Application Date";
                "Card No" := ATMApp."Card No";
                Limit := ATMApp.Limit;
                "Terms Read and Understood" := ATMApp."Terms Read and Understood";
                "Form No" := ATMApp."Form No";
                "Sent To External File" := ATMApp."Sent To External File";
                "Card Status" := ATMApp."Card Status";
                "Replacement For Card No" := ATMApp."Replacement For Card No";
                "Phone No." := ATMApp."Phone No.";
                Collected := ATMApp.Collected;
                "Approval Date" := Today;
                "Posted By." := ATMApp."Posted By.";
                "Responsibility Center" := ATMApp."Responsibility Center";
                "Shortcut Dimension 1 Code" := ATMApp."Shortcut Dimension 1 Code";
                "Shortcut Dimension 2 Code" := ATMApp."Shortcut Dimension 2 Code";
                "ATM Charges Applied" := ATMApp."ATM Charges Applied";
                "ATM Charged Date" := ATMApp."ATM Charged Date";
                "Card Type" := ATMApp."Card Type";
                "Sales Agent" := ATMApp."Sales Agent";
            end;
        }
        field(50057; "ATM Linking Statistics"; Integer)
        {
            CalcFormula = Count("ATM Linking  Statistics" WHERE("Account No." = FIELD("Account No")));
            Editable = false;
            FieldClass = FlowField;
            Caption = 'ATM Linking Statistics';
        }
        field(50058; "Sales Agent"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser".Code;
            Caption = 'Sales Agent';
            DataClassification = CustomerContent;
        }
        field(50059; "Captured By"; Code[50])
        {
            Editable = false;
            Caption = 'Captured By';
            DataClassification = CustomerContent;
        }
        field(50060; "Capture Date"; Date)
        {
            Editable = false;
            Caption = 'Capture Date';
            DataClassification = CustomerContent;
        }
        field(50061; "Approved  By"; Code[50])
        {
            Editable = false;
            Caption = 'Approved  By';
            DataClassification = CustomerContent;
        }
        field(50062; "Linked ATM Card No."; Code[20])
        {
            Editable = false;
            Caption = 'Linked ATM Card No.';
            DataClassification = CustomerContent;
        }
        field(50063; "ATM Card No.[ Linked ]"; Code[20])
        {
            Editable = false;
            FieldClass = Normal;
            Caption = 'ATM Card No.[ Linked ]';
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
            BankingNoSetup.Get();
            BankingNoSetup.TestField(BankingNoSetup."ATM Linking Application Nos");
            
        end;
        "Application Date" := Today;
        "Captured By" := UserId;
        "Capture Date" := Today;
    end;

    var
        GeneralSetUp: Record "General Set-Up";
        BankingNoSetup: Record "Banking No. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        ATMApplications: Record "ATM Linking Applications";
        ATMApp: Record "ATM Applications";
        SavingsACC: Record "Account Banking";
        ATMCount: Integer;
        ATMLinkingApplications: Record "ATM Linking Applications";
}




