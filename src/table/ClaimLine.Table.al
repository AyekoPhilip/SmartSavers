table 50136 "Claim Line"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Claim No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Claim No';
        }
        field(50010; "Line No"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No';
        }
        field(50011; "Patient No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Patient No';
        
            trigger OnValidate()
            begin
                /* Cheruiyot
                Beneficiary.Reset();
                Beneficiary.SetRange(Beneficiary."Employee Code","Patient No");
                if Beneficiary.Find('-')then
                "Patient Name":=Beneficiary.SurName+' '+Beneficiary."Other Names";
                */





                /*
                  TestField("Visit Date");
                   MedSchemeLines.Reset();
                  MedSchemeLines.SetRange(MedSchemeLines."Employee Code","Employee No");
                  MedSchemeLines.SetRange(MedSchemeLines."Line No.","Patient No");
                  if MedSchemeLines.Find('+') then
                  "Patient Name":=MedSchemeLines."Other Names"+' '+MedSchemeLines.SurName;
                  Relationship:=MedSchemeLines.Relationship;
                */

            end;
        }
        field(50012; "Patient Name"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Patient Name';
        }
        field(50013; "Hospital/Specialist"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Hospital/Specialist';
        }
        field(50014; "Invoice Number"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Invoice Number';
        
            trigger OnValidate()
            begin
                /*
                 claims.Reset();
                 claims.SetRange(claims."Claim No","Claim No");
                 claims.SetRange(claims."Employee No","Employee No");
                 if claims.Find('-') then begin
                  if claims."Invoice Number"="Invoice Number" then
                   Error('That Invoice number has already been captured!');
                 end;
                 */

            end;
        }
        field(50015; "Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Amount';
        
            trigger OnValidate()
            begin
                /*
                "Approved Amount":=Amount;
                MedicalSheme.Reset();
                MedicalSheme.SetRange(MedicalSheme."Employee No","Employee No");
                if MedicalSheme.Find('+') then
                begin
                 MedicalSheme.CalcFields(MedicalSheme."In-Patient Claims",MedicalSheme."Out-Patient Claims");
                 if Amount+MedicalSheme."In-Patient Claims">MedicalSheme."Entitlement -Inpatient"  then
                 Message('By Accepting this claim you will be exceed the in-patient limit');

                 if Amount+MedicalSheme."Out-Patient Claims">MedicalSheme."Entitlement -OutPatient"  then
                 Message('By Accepting this claim you will be exceed the out-patient limit');


                end;
                */

            end;
        }
        field(50016; "Approved Amount"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Approved Amount';
        }
        field(50017; "Employee No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee No';
        
            trigger OnValidate()
            begin
                if emp.Get("Employee No") then
                    "Employee Name" := emp."First Name" + ' ' + emp."Middle Name" + ' ' + emp."Last Name";
            end;
        }
        field(50018; "Medical Scheme"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Medical Scheme';
        }
        field(50019; "Status"; Option)
        {
            DataClassification = CustomerContent;
            OptionMembers = " ","Approved","Rejected","Part Payment";
            Caption = 'Status';
        }
        field(50020; "Amount Spend (In-Patient)"; Decimal)
        {
            FieldClass = Normal;
            DataClassification = CustomerContent;
            Caption = 'Amount Spend (In-Patient)';
        }
        field(50021; "Amout Spend (Out-Patient)"; Decimal)
        {
            FieldClass = Normal;
            DataClassification = CustomerContent;
            Caption = 'Amout Spend (Out-Patient)';
        }
        field(50022; "Claim Type"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ' ,In Patient,Out Patient,Dental,Optical';
            OptionMembers = " ","In Patient","Out Patient","Dental","Optical";
            Caption = 'Claim Type';
        }
        field(50023; "Balance (In-Patient)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Balance (In-Patient)';
        }
        field(50024; "Balance (Out-Patient)"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Balance (Out-Patient)';
        }
        field(50025; "Visit Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Visit Date';
        
            trigger OnValidate()
            begin
                AccountingP.Reset();
                AccountingP.SetRange(AccountingP."Starting Date", 0D, "Visit Date");
                AccountingP.SetRange(AccountingP."New Fiscal Year", true);
                if AccountingP.Find('+') then
                    "Policy Start Date" := AccountingP."Starting Date";
            end;
        }
        field(50026; "Employee Name"; Text[80])
        {
            DataClassification = CustomerContent;
            Caption = 'Employee Name';
        }
        field(50027; "Relationship"; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Relative;
            Caption = 'Relationship';
        }
        field(50028; "Policy Start Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Policy Start Date';
        }
        field(50029; "Commissioner Code"; Code[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Commissioner Code';
        
            trigger OnValidate()
            begin
                dimvalue.Reset();
                if dimvalue.Get('COMMISSIONERS', "Commissioner Code") then
                    "Commissioner Name" := dimvalue.Name;
            end;
        }
        field(50030; "Commissioner Name"; Text[50])
        {
            DataClassification = CustomerContent;
            Caption = 'Commissioner Name';
        }
        field(50031; "Settled"; Boolean)
        {
            DataClassification = CustomerContent;
            Caption = 'Settled';
        }
        field(50032; "Cheque No"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cheque No';
        }
        field(50033; "Directorate"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Directorate';
        }
        field(50034; "Department"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Department';
        }
        field(50035; "LineNo"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'LineNo';
        }
        field(50036; "Patient"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = ',Self,Dependant';
            OptionMembers = "","Self","Dependant";
            Caption = 'Patient';
        
            trigger OnValidate()
            begin
                if Patient = Patient::Self then
                    "Patient Name" := "Employee Name";
            end;
        }
    }

    keys
    {
        key("Key1"; "Claim No")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        AccountingP: Record "Accounting Period";
        dimvalue: Record "Dimension Value";
        emp: Record Employee;
}


