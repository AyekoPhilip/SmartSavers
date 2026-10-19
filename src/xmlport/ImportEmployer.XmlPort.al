xmlport 50005 "ImportEmployer"
{
    Caption = 'Import Members';
    Direction = Both;
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement(CustomerMember; Member)
            {
                fieldelement(No; CustomerMember."No.")
                {
                }
                fieldelement(Name; CustomerMember.Name)
                {
                }
                fieldelement(Gender; CustomerMember.Gender)
                {
                }
                fieldelement(MaritStatus; CustomerMember."Marital Status")
                {
                }
                fieldelement(RejoinDate; CustomerMember."Rejoining Date")
                {
                }
                fieldelement(PhoneNo; CustomerMember."Phone No.")
                {
                }
                fieldelement(IDNo; CustomerMember."ID No.")
                {

                }
                fieldelement(PassPortNo; CustomerMember."Passport No.")
                {
                }
                fieldelement(AgencyCode; CustomerMember."Station/Department")
                {
                }
                fieldelement(Address; CustomerMember."Current Address")
                {
                }
                fieldelement(DateOfBirth; CustomerMember."Date of Birth")
                {
                }
                fieldelement(Rejoined; CustomerMember.Rejoined)
                {
                }
                fieldelement(EmpCode; CustomerMember."Employer Code")
                {
                }
                fieldelement(MembCategory; CustomerMember."Member Category")
                {
                }
                fieldelement(EmailAddress; CustomerMember."E-Mail")
                {
                }
                fieldelement(RegDate; CustomerMember."Registration Date")
                {
                }
                fieldelement(Status; CustomerMember.Status)
                {
                }
                fieldelement(MobilePhone; CustomerMember."Mobile Phone No")
                {
                }
                fieldelement(RectruitedBy; CustomerMember."Recruited By")
                {
                }
                fieldelement(EmailPersonal; CustomerMember."E-mail (Personal)")
                {
                }
                fieldelement(PinNo; CustomerMember."PIN No.")
                {
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
}



