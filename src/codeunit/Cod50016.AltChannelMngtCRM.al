codeunit 50016 "Alt. Channel Mngt. CRM"
{
    trigger OnRun()
    begin

    end;

    var
        CrmApplication: Record "CRM Application";
        CrmApplic: Record "CRM Application";

    procedure InsertCrmEntries(AppNoTxt: Code[50]; AppFormNoTxt: Code[100]; MemberNoTxt: Code[100]; ApplicTypeTxt: Enum CrmApplicationType; AccNameTxt: Text[250]; ProdTypeTxt: Code[20]; PayrollNoTxt: Code[50]; IDNoTxt: Code[20]; ReqAmtTxt: Decimal; DateOfBirthTxt: Date; IdenTypeTxt: Enum MemberIdentificationType) Responce: Text[250]
    begin
        CrmApplic.Reset();
        CrmApplic.SetRange("No.", AppNoTxt);
        if not CrmApplic.FindFirst() then begin
            CreateCrmEntries(AppNoTxt, AppFormNoTxt,
            MemberNoTxt, ApplicTypeTxt, AccNameTxt,
            ProdTypeTxt, PayrollNoTxt, IDNoTxt,
            ReqAmtTxt, DateOfBirthTxt, IdenTypeTxt);
            CrmApplication.Reset();
            CrmApplication.SetRange("No.", AppNoTxt);
            if CrmApplication.FindFirst() then begin
                Responce := '00|' + CrmApplication."No."
            end else begin
                Responce := '99|Failed'
            end;
        end else begin
            Responce := '99|CRM No. already allocated.'
        end;

    end;

    procedure CreateCrmEntries(AppNo: Code[50]; AppFormNo: Code[100]; MemberNo: Code[100]; ApplicType: Enum CrmApplicationType; AccName: Text[250]; ProdType: Code[20]; PayrollNo: Code[50]; IDNo: Code[20]; ReqAmt: Decimal; DateOfBirth: Date; IdenType: Enum MemberIdentificationType)
    var
        CrmApp: Record "CRM Application";
    begin

        CrmApp.Init();
        CrmApp."No." := AppNo;
        CrmApp."Application Form No." := AppFormNo;
        CrmApp."Member No." := MemberNo;
        CrmApp."Application Type" := ApplicType;
        CrmApp.Validate(Name, AccName);
        CrmApp."Product Type" := ProdType;
        CrmApp."Payroll No." := PayrollNo;
        CrmApp."ID No." := IDNo;
        CrmApp."Date of Birth" := DateOfBirth;
        CrmApp."Requested Amount" := ReqAmt;
        CrmApp."Identification Type" := IdenType;
        CrmApp.Insert(true)
    end;

    procedure getLoanStatus()
    begin

    end;
}



