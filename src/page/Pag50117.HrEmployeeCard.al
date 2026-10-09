page 50117 "Hr Employee Card"
{
    ApplicationArea = All;
    Caption = 'Employee Card';
    PageType = Card;
    DeleteAllowed = false;
    SourceTable = "HR Employees";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                    ShowMandatory = true;
                }
                field("First Name"; Rec."First Name")
                {
                    ToolTip = 'Specifies the value of the First Name field.';
                    Style = StandardAccent;
                    Importance = Additional;
                    StyleExpr = true;
                    Editable = false;
                }
                field("Middle Name"; Rec."Middle Name")
                {
                    ToolTip = 'Specifies the value of the Middle Name field.';
                    Style = StandardAccent;
                    Importance = Additional;
                    Editable = false;
                    StyleExpr = true;
                }
                field("Last Name"; Rec."Last Name")
                {
                    ToolTip = 'Specifies the value of the Last Name field.';
                    Style = StandardAccent;
                    Importance = Additional;
                    Editable = false;
                    StyleExpr = true;
                }
                field("ID No."; Rec."ID No.")
                {
                    ToolTip = 'Specifies the value of the ID No. field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Initials; Rec.Initials)
                {
                    ToolTip = 'Specifies the value of the Initials field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("User ID"; Rec."User ID")
                {
                    ToolTip = 'Specifies the value of the User ID field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Department Code"; Rec."Department Code")
                {
                    ToolTip = 'Specifies the value of the Department Code field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Gender; Rec.Gender)
                {
                    ToolTip = 'Specifies the value of the Gender field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Marital Status"; Rec."Marital Status")
                {
                    ToolTip = 'Specifies the value of the Marital Status field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;

                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                    Editable = true;


                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Appraisal Method"; Rec."Appraisal Method")
                {
                    ToolTip = 'Specifies the value of the Appraisal Method field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(Disabled; Rec.Disabled)
                {
                    ToolTip = 'Specifies the value of the Disabled field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Posting Group"; Rec."Posting Group")
                {
                    ToolTip = 'Specifies the value of the Posting Group field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Supervisor Code"; Rec."Supervisor Code")
                {
                    ToolTip = 'Specifies the value of the Supervisor Code field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Member No."; Rec."Member No.")
                {
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

                field("Termination Grounds"; Rec."Termination Grounds")
                {
                    ToolTip = 'Specifies the value of the Termination Grounds field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            group("Communication Details")
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Post Code"; Rec."Post Code")
                {
                    ToolTip = 'Specifies the value of the Post Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Postal Address"; Rec."Postal Address")
                {
                    ToolTip = 'Specifies the value of the Postal Address field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Phone No."; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Mobile Phone No."; Rec."Mobile Phone No.")
                {
                    ToolTip = 'Specifies the value of the Mobile Phone No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Company E-Mail"; Rec."Company E-Mail")
                {
                    ToolTip = 'Specifies the value of the Company E-Mail field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
            }
            group("Job Details")
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;

                field("Job ID"; Rec."Job ID")
                {
                    ToolTip = 'Specifies the value of the Job ID field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.';
                    ShowMandatory = true;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Salary Grade"; Rec."Salary Grade")
                {
                    ToolTip = 'Specifies the value of the Salary Grade field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field(Grade; Rec.Grade)
                {
                    ToolTip = 'Specifies the value of the Grade field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Full/Part Time"; Rec."Full/Part Time")
                {
                    ToolTip = 'Specifies the value of the Full/Part Time field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }

            }
            group("Important Dates")
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;
                field("Contract End Date"; Rec."Contract End Date")
                {
                    ToolTip = 'Specifies the value of the Contract End Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date Of Birth"; Rec."Date Of Birth")
                {
                    ToolTip = 'Specifies the value of the Date Of Birth field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Date of Join"; Rec."Date of Join")
                {
                    ToolTip = 'Specifies the value of the Date of Join field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Date of Leaving"; Rec."Date of Leaving")
                {
                    ToolTip = 'Specifies the value of the Date of Leaving field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Date of Leaving Company"; Rec."Date of Leaving Company")
                {
                    ToolTip = 'Specifies the value of the Date of Leaving Company field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Demised Date"; Rec."Demised Date")
                {
                    ToolTip = 'Specifies the value of the Demised Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Contract Type"; Rec."Contract Type")
                {
                    ToolTip = 'Specifies the value of the Contract Type field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Contracted Hours"; Rec."Contracted Hours")
                {
                    ToolTip = 'Specifies the value of the Contracted Hours field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("End of Contract Date"; Rec."End of Contract Date")
                {
                    ToolTip = 'Specifies the value of the End of Contract Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("End of Probation Date"; Rec."End of Probation Date")
                {
                    ToolTip = 'Specifies the value of the End of Probation Date field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Exit Interview Date"; Rec."Exit Interview Date")
                {
                    ToolTip = 'Specifies the value of the Exit Interview Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Retirement Date"; Rec."Retirement Date")
                {
                    ToolTip = 'Specifies the value of the Retirement Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Retrenchment Date"; Rec."Retrenchment Date")
                {
                    ToolTip = 'Specifies the value of the Retrenchment Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Suspension Date"; Rec."Suspension Date")
                {
                    ToolTip = 'Specifies the value of the Suspension Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Probation Duration"; Rec."Probation Duration")
                {
                    ToolTip = 'Specifies the value of the Probation Duration field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Resignation Date"; Rec."Resignation Date")
                {
                    ToolTip = 'Specifies the value of the Resignation Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Pension Scheme Join Date"; Rec."Pension Scheme Join Date")
                {
                    ToolTip = 'Specifies the value of the Pension Scheme Join Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Statutory Information")
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;

                field("HELB No."; Rec."HELB No.")
                {
                    ToolTip = 'Specifies the value of the HELB No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("NHIF No."; Rec."NHIF No.")
                {
                    ToolTip = 'Specifies the value of the NHIF No. field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("NSSF No."; Rec."NSSF No.")
                {
                    ToolTip = 'Specifies the value of the NSSF No. field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("PIN No."; Rec."PIN No.")
                {
                    ToolTip = 'Specifies the value of the PIN No. field.';
                    Style = StandardAccent;
                    ShowMandatory = true;
                    StyleExpr = true;
                }
                field("Passport No."; Rec."Passport No.")
                {
                    ToolTip = 'Specifies the value of the Passport No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Social Security No."; Rec."Social Security No.")
                {
                    ToolTip = 'Specifies the value of the Social Security No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

            }
            group("Pension and Medical")
            {
                Editable = Rec."Approval Status" = Rec."Approval Status"::Open;

                field("Medical Scheme Join";
                Rec."Medical Scheme Join")
                {
                    ToolTip = 'Specifies the value of the Medical Scheme Join field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Medical Scheme Join Date"; Rec."Medical Scheme Join Date")
                {
                    ToolTip = 'Specifies the value of the Medical Scheme Join Date field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Medical Scheme No."; Rec."Medical Scheme No.")
                {
                    ToolTip = 'Specifies the value of the Medical Scheme No. field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
            group("Trail Information")
            {
                Editable = true;

                field("Responsibility Centre"; Rec."Responsibility Centre")
                {
                    ToolTip = 'Specifies the value of the Responsibility Centre field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }

                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control13; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control18; MyNotes)
            {
                ApplicationArea = All;
            }

            part(Picture; "Hr Employee Picture")
            {
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;
            }
            part(EmployeeFactbox; "Employee Factbox")
            {
                Caption = 'Employee Factbox';
                SubPageLink = "No." = field("No.");
                ApplicationArea = All;

            }

        }
    }
    actions
    {
        area(navigation)
        {
            group("E&mployee")
            {
                Caption = 'E&mployee';
                Image = Employee;
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Human Resource Comment Sheet";
                    RunPageLink = "Table Name" = const(Employee),
                                  "No." = field("No.");
                    ToolTip = 'View or add comments for the record.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(5200),
                                  "No." = field("No.");
                    ShortCutKey = 'Alt+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("&Picture")
                {
                    ApplicationArea = BasicHR;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Employee Picture";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'View or add a picture of the employee or, for example, the company''s logo.';
                }
                action(AlternativeAddresses)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Alternate Addresses';
                    Image = Addresses;
                    RunObject = Page "Alternative Address List";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of addresses that are registered for the employee.';
                }
                action("&Relatives")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Relatives';
                    Image = Relatives;
                    RunObject = Page "Employee Relatives";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of relatives that are registered for the employee.';
                }
                action("Mi&sc. Article Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Mi&sc. Article Information';
                    Image = Filed;
                    RunObject = Page "Misc. Article Information";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of miscellaneous articles that are registered for the employee.';
                }
                action("&Confidential Information")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Confidential Information';
                    Image = Lock;
                    RunObject = Page "Confidential Information";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of any confidential information that is registered for the employee.';
                }
                action("Q&ualifications")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Q&ualifications';
                    Image = Certificate;
                    RunObject = Page "Employee Qualifications";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'Open the list of qualifications that are registered for the employee.';
                }
                action("A&bsences")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'A&bsences';
                    Image = Absence;
                    RunObject = Page "Employee Absences";
                    RunPageLink = "Employee No." = field("No.");
                    ToolTip = 'View absence information for the employee.';
                }
                separator(Action23)
                {
                }
                action("Absences by Ca&tegories")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Absences by Ca&tegories';
                    Image = AbsenceCategory;
                    RunObject = Page "Empl. Absences by Categories";
                    RunPageLink = "No." = field("No."),
                                  "Employee No. Filter" = field("No.");
                    ToolTip = 'View categorized absence information for the employee.';
                }
                action("Misc. Articles &Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Misc. Articles &Overview';
                    Image = FiledOverview;
                    RunObject = Page "Misc. Articles Overview";
                    ToolTip = 'View miscellaneous articles that are registered for the employee.';
                }
                action("Co&nfidential Info. Overview")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Co&nfidential Info. Overview';
                    Image = ConfidentialOverview;
                    RunObject = Page "Confidential Info. Overview";
                    ToolTip = 'View confidential information that is registered for the employee.';
                }
                separator(Action61)
                {
                }
                action("Ledger E&ntries")
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Ledger E&ntries';
                    Image = VendorLedger;
                    RunObject = Page "Employee Ledger Entries";
                    RunPageLink = "Employee No." = field("No.");
                    RunPageView = sorting("Employee No.")
                                  order(Descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
                action(Attachments)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
                action(PayEmployee)
                {
                    ApplicationArea = BasicHR;
                    Caption = 'Pay Employee';
                    Image = SuggestVendorPayments;
                    RunObject = Page "Pr Salary List";
                    RunPageLink = "No." = field("No.");
                    ToolTip = 'View employee ledger entries for the record with remaining amount that have not been paid yet.';
                }
                action(Contact)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Contact';
                    Image = ContactPerson;
                    ToolTip = 'View or edit detailed information about the contact person at the employee.';

                    trigger OnAction()
                    var
                        ContBusRel: Record "Contact Business Relation";
                        Contact: Record Contact;
                    begin
                        if ContBusRel.FindByRelation(ContBusRel."Link to Table"::Employee, Rec."No.") then begin
                            Contact.Get(ContBusRel."Contact No.");
                            Page.Run(Page::"Contact Card", Contact);
                        end;
                    end;
                }
            }
            group(ApprovalT)
            {
                Caption = 'Approvals';

                action(SendApprovalRequest)
                {
                    Caption = 'Send A&pproval Request';
                    Image = SendApprovalRequest;
                    ApplicationArea = All;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        LoanApp: Record Loans;
                        ProdFac: Record "Product Factory";
                        LoanGuarantorsandSecurity: Record "Loan Guarantors and Security";
                        TotGuarant: Decimal;
                    begin
                        Rec.fnApprovalRequest(Enum::ActionPanesItems::"Send Approval Request");
                        CurrPage.Close();
                    end;
                }
                action(CancelApprovalRequest)
                {
                    Caption = 'Cancel Approval Re&quest';
                    Image = CancelApprovalRequest;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        Rec.fnApprovalRequest(Enum::ActionPanesItems::"Cancel Approval Request");
                        CurrPage.Close();
                    end;
                }
                action("Open Document")
                {
                    Image = Category;
                    Caption = 'Open Approval Request';
                    Visible = true;
                    ApplicationArea = All;
                    trigger OnAction()
                    begin
                        Rec.fnApprovalRequest(Enum::ActionPanesItems::"Open Request");
                        CurrPage.Close();
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate';
                    Enabled = Rec."Approval Status" = Rec."Approval Status"::"Pending Approval";
                    Image = Delegate;
                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec.fnApprovalRequest(Enum::ActionPanesItems::Delegate);
                    end;
                }

                action(Approvals)
                {
                    Caption = 'Approvals';
                    Image = Approval;

                    ApplicationArea = All;
                    trigger OnAction()
                    var
                        ApprovalEntries: Page "Approval Entries";
                        approvalsMgmt: Codeunit "Approval Mgmt.";
                    begin
                        Rec.fnApprovalRequest(Enum::ActionPanesItems::Approvals);
                    end;
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Sent Emails")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sent Emails';
                    Image = ShowList;
                    ToolTip = 'View a list of emails that you have sent to this employee.';

                    trigger OnAction()
                    var
                        Email: Codeunit Email;
                    begin
                        Email.OpenSentEmails(Database::Employee, Rec.SystemId);
                    end;
                }
            }
        }
        area(Processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(ApplyTemplate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    ToolTip = 'Apply a template to update the entity with your standard settings for a certain type of entity.';

                    trigger OnAction()
                    var
                        EmployeeTemplMgt: Codeunit "Employee Templ. Mgt.";
                    begin
                        // EmployeeTemplMgt.UpdateEmployeeFromTemplate(Rec);
                    end;
                }
                action(SaveAsTemplate)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Save as Template';
                    Ellipsis = true;
                    Image = Save;
                    ToolTip = 'Save the employee card as a template that can be reused to create new employee cards. Employee templates contain preset information to help you fill fields on employee cards.';

                    trigger OnAction()
                    var
                        EmployeeTemplMgt: Codeunit "Employee Templ. Mgt.";
                    begin
                        //EmployeeTemplMgt.SaveAsTemplate(Rec);
                    end;
                }
            }
            action(Email)
            {
                ApplicationArea = All;
                Caption = 'Send Email';
                Image = Email;
                ToolTip = 'Send an email to this employee.';

                trigger OnAction()
                var
                    TempEmailItem: Record "Email Item" temporary;
                    EmailScenario: Enum "Email Scenario";
                begin
                    TempEmailItem.AddSourceDocument(Database::"HR Employees", Rec.SystemId);
                    if Rec."E-Mail" <> '' then
                        TempEmailitem."Send to" := Rec."E-Mail"
                    else
                        TempEmailitem."Send to" := Rec."E-Mail";
                    TempEmailItem.Send(false, EmailScenario::Default);
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process', Comment = 'Generated from the PromotedActionCategories property index 1.';

                actionref(Email_Promoted; Email)
                {
                }
                actionref(PayEmployee_Promoted; PayEmployee)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Employee', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Dimensions_Promoted; Dimensions)
                {
                }
                actionref("Co&mments_Promoted"; "Co&mments")
                {
                }
                actionref(Attachments_Promoted; Attachments)
                {
                }
                actionref(Contact_Promoted; Contact)
                {
                }
                actionref("Sent Emails_Promoted"; "Sent Emails")
                {
                }
                actionref("&Picture_Promoted"; "&Picture")
                {
                }
                actionref("&Confidential Information_Promoted"; "&Confidential Information")
                {
                }
                actionref("Q&ualifications_Promoted"; "Q&ualifications")
                {
                }
                actionref("A&bsences_Promoted"; "A&bsences")
                {
                }
                actionref("Ledger E&ntries_Promoted"; "Ledger E&ntries")
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Navigate', Comment = 'Generated from the PromotedActionCategories property index 4.';

            }
            group(Category_Report)
            {
                Caption = 'Report', Comment = 'Generated from the PromotedActionCategories property index 2.';
            }
        }
    }

    var
        EmployeeCard: page "Employee Card";
}
