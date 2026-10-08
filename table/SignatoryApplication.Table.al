table 50358 "Signatory Application"
{
    DataClassification = CustomerContent;

    fields
    {
        field(50009; "Entry No"; Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No';
            DataClassification = CustomerContent;
        }
        field(50010; "Account No."; Code[20])
        {
            NotBlank = true;
            Caption = 'Account No.';
            DataClassification = CustomerContent;
        }
        field(50011; "Names"; Text[50])
        {
            Editable = false;
            NotBlank = true;
            Caption = 'Name';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                NameBreakdown();
            end;
        }
        field(50012; "Date Of Birth"; Date)
        {
            Caption = 'Date Of Birth';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                DateofBirthError: Label 'This date cannot be greater than today.';
                MinimumAgeError: Label 'Minimum Member age must not be below %1';
            begin
                if "Date Of Birth" > Today then
                    Error(DateofBirthError);
                Gensetup.Get();
                Gensetup.TestField("Min. Member Age");
                if CalcDate(Gensetup."Min. Member Age", "Date of Birth") > Today then
                    Error(MinimumAgeError, Gensetup."Min. Member Age");
            end;
        }
        field(50013; "Staff/Payroll"; Code[20])
        {
            Caption = 'Staff/Payroll';
            DataClassification = CustomerContent;
        }
        field(50014; "ID No."; Code[50])
        {
            Caption = 'ID No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin
                fnValidateID();
            end;
        }
        field(50015; "Signatory"; Boolean)
        {
            Caption = 'Signatory';
            DataClassification = CustomerContent;
        }
        field(50016; "Must Sign"; Boolean)
        {
            Caption = 'Must Sign';
            DataClassification = CustomerContent;
        }
        field(50017; "Must be Present"; Boolean)
        {
            Caption = 'Must be Present';
            DataClassification = CustomerContent;
        }
        field(50018; "Picture"; Media)
        {
            Caption = 'Picture';
            DataClassification = CustomerContent;
        }
        field(50019; "Signature"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50020; "Expiry Date"; Date)
        {
            Caption = 'Expiry Date';
            DataClassification = CustomerContent;
        }
        field(50021; "Type"; Code[20])
        {
            TableRelation = "Segment/County/Dividend/Signat".Code WHERE(Type = FILTER("Signatory Type"));
            Caption = 'Type';
            DataClassification = CustomerContent;
        }
        field(50022; "Member No."; Code[100])
        {
            TableRelation = IF ("Signatory Category" = CONST(Member)) Member."No." WHERE("Group Account" = CONST(false))
            ELSE
            IF ("Signatory Category" = CONST(Staff)) Employee."No.";
            Caption = 'Member No.';
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                Members: Record Member;
                ImageData: Record "Image Data";
            begin
                if Members.Get("Member No.") then begin
                    Validate(Names, Members.Name);
                    Validate("ID No.", Members."ID No.");
                    Validate("Date Of Birth", Members."Date of Birth");
                    "Staff/Payroll" := Members."Payroll/Staff No.";
                    "Pin No." := Members."PIN No.";
                    "Passport No." := Members."Passport No.";
                    Gender := Members.Gender;
                    City := Members.City;
                    Nationality := Members.Nationality;
                    Address := Members."Current Address";
                    ImageData.Reset;
                    ImageData.SetRange("ID No.", Members."ID No.");
                    if ImageData.Find('-') then begin
                        Picture := ImageData.Picture;
                        Signature := ImageData.Signature;
                    end;
                end;
            end;
        }
        field(50023; "Entry Type"; Option)
        {
            OptionCaption = 'Initial,Changes';
            OptionMembers = "Initial","Changes";
            Caption = 'Entry Type';
            DataClassification = CustomerContent;
        }
        field(50024; "Signatory Category"; Option)
        {
            DataClassification = CustomerContent;
            OptionCaption = 'Member,Staff,Non Member';
            OptionMembers = "Member","Staff","Non Member";
            Caption = 'Signatory Category';
        
            trigger OnValidate()
            begin
                if "Signatory Category" = "Signatory Category"::"Non Member" then begin
                    Names := '';
                    "ID No." := '';
                    "Date Of Birth" := 0D;
                    "Staff/Payroll" := '';
                    "Pin No." := '';
                    "Passport No." := '';
                    Gender := Gender::" ";
                    City := '';
                    Nationality := '';
                    Address := '';
                end
            end;
        }
        field(50025; "Non Member A/c No."; Code[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Non Member A/c No.';
        }
        field(50026; "First Name"; Text[30])
        {
            Caption = 'First Name';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                "First Name" := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Names := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50027; "Second Name"; Text[30])
        {
            Caption = 'Second Name';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                "Second Name" := DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Names := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50028; "Pin No."; Code[20])
        {
            Caption = 'Pin No.';
            DataClassification = CustomerContent;
        }
        field(50029; "Occupation"; Text[30])
        {
            Caption = 'Occupation';
            DataClassification = CustomerContent;
        }
        field(50030; "Gender"; Enum "CustGender")
        {
            Caption = 'Gender';
            DataClassification = CustomerContent;
        }
        field(50031; "Address"; Code[100])
        {
            Caption = 'Address';
            DataClassification = CustomerContent;
        }
        field(50032; "Apartment/Suite"; Code[10])
        {
            Caption = 'Apartment/Suite';
            DataClassification = CustomerContent;
        }
        field(50033; "State ID"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'State ID';
        }
        field(50034; "State"; Code[10])
        {
            DataClassification = CustomerContent;
            TableRelation = States.Code;
            Caption = 'State';
        }
        field(50035; "Zip Code"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Zip Code';
        }
        field(50036; "Post Code"; Code[20])
        {
            Caption = 'Post Code';
            TableRelation = IF (Nationality = CONST('')) "Post Code"
            ELSE
            IF (Nationality = FILTER(<> '')) "Post Code";
            ValidateTableRelation = false;
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidatePostCode(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50037; "Nationality"; Code[10])
        {
            Caption = 'Nationality';
            TableRelation = "Country/Region";
            DataClassification = CustomerContent;
        
            trigger OnValidate()
            begin

            end;
        }
        field(50038; "City"; Text[30])
        {
            Caption = 'City';
            DataClassification = CustomerContent;
            TableRelation = if (Nationality = const()) "Post Code".City
            else
            if (Nationality = filter(<> '')) "Post Code".City where("Country/Region Code" = field(Nationality));
            ValidateTableRelation = false;
        
            trigger OnValidate()
            var
                PostCode: Record "Post Code";
            begin
                PostCode.ValidateCity(City, "Post Code", County, Nationality, (CurrFieldNo <> 0) AND GUIALLOWED);
            end;
        }
        field(50039; "ID Image"; Media)
        {
            Caption = 'Signature';
            DataClassification = CustomerContent;
        }
        field(50040; "Last Name"; Text[50])
        {
            Caption = 'Last Name';
            DataClassification = CustomerContent;
            Editable = false;
        
            trigger OnValidate()
            begin
                "Last Name" := DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
                Names := DelChr("First Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Second Name", '=', '0|1|2|3|4|5|6|7|8|9') + ' ' +
                DelChr("Last Name", '=', '0|1|2|3|4|5|6|7|8|9');
            end;
        }
        field(50041; "Mobile No."; Code[10])
        {
            Caption = 'Mobile No.';
            DataClassification = CustomerContent;
        }
        field(50042; "Passport No."; Text[30])
        {
            DataClassification = CustomerContent;
            Caption = 'Passport No.';
        }
        field(50043; "Status"; Option)
        {
            DataClassification = CustomerContent;
            Editable = false;
            OptionCaption = 'Open,Pending,Approved,Rejected,Created';
            OptionMembers = "Open","Pending","Approved","Rejected","Created";
            Caption = 'Status';
        }
        field(50044; "County"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'County';
        }
    }


    keys
    {
        key("Key1"; "Account No.", "ID No.")
        {
            Clustered = true;
        }
        key("Key2"; "Entry No")
        {

        }
    }

    fieldgroups
    {
    }
    var
        Gensetup: Record "General Set-Up";

    local procedure NameBreakdown()
    var
        NamePart: array[30] of Text[100];
        TempName: Text[250];
        FirstName250: Text[250];
        i: Integer;
        NoOfParts: Integer;

    begin
        TempName := Names;
        while STRPOS(TempName, ' ') > 0 do begin
            IF STRPOS(TempName, ' ') > 1 then begin
                i := i + 1;
                NamePart[i] := COPYSTR(TempName, 1, STRPOS(TempName, ' ') - 1);
            end;
            TempName := COPYSTR(TempName, STRPOS(TempName, ' ') + 1);
        end;
        i := i + 1;
        NamePart[i] := COPYSTR(TempName, 1, MAXSTRLEN(NamePart[i]));
        NoOfParts := i;
        "First Name" := '';
        "Second Name" := '';
        "Last Name" := '';
        for i := 1 TO NoOfParts do
            IF (i = NoOfParts) and (NoOfParts > 1) then
                "Last Name" := COPYSTR(NamePart[i], 1, MAXSTRLEN("Last Name"))
            else
                IF (i = NoOfParts - 1) and (NoOfParts > 2) then
                    "Second Name" := COPYSTR(NamePart[i], 1, MAXSTRLEN("Second Name"))
                else begin
                    FirstName250 := DELCHR("First Name" + ' ' + NamePart[i], '<', ' ');
                    "First Name" := COPYSTR(FirstName250, 1, MAXSTRLEN("First Name"));
                end;
    end;

    local procedure fnValidateID()
    var
        MemberExistError: Label 'Already exists with member %1 Name: %2';
        Cust: Record "Account Signatories";
    begin
        "ID No." := DELCHR("ID No.", '=', 'A|B|C|D|E|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|.|,|!|@|#|$|%|^|&|*|(|)|[|]|{|}|/|\|"|;|:|<|>|?|+|-|_');
        FieldLength("ID No.", 10);

        /* Cust.RESET;
         Cust.SETRANGE(Cust."ID No.","ID No.");
          IF Cust.FindFirst() then
        Error(MemberExistError,Cust."ID No.",Cust.Names); */
    end;

    local procedure FieldLength(VarVariant: Text; FldLength: Integer): Text[50]
    var
        FieldLengthError: Label 'Field cannot be more than %1 Characters.';
    begin
        IF STRLEN(VarVariant) > FldLength THEN
            ERROR(FieldLengthError, FldLength);
    end;
}




