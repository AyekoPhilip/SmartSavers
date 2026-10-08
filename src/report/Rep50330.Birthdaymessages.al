report 50330 "Birthday messages"
{
    DefaultLayout = RDLC;
    RDLCLayout = './src/report_layout/Birthdaymessages.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Member; Member)
        {
            RequestFilterFields = "No.";
            column(PhoneNo_Members; "Phone No.")
            {
            }
            column(No_Members; "No.")
            {
            }
            column(Name_Members; Name)
            {
            }
            column(DateofBirth_Members; "Date of Birth")
            {
            }

            trigger OnAfterGetRecord()
            var
                NotifSource: Enum NotifSourceType;
            begin


                Birthday := '';
                TDay := '';
                DayA := 0;
                DayB := 0;
                MonthA := 0;
                MonthB := 0;
                YearA := 0;
                YearB := 0;


                if Member."Date of Birth" <> 0D then
                    DayB := Date2DMY("Date of Birth", 1);
                MonthB := Date2DMY("Date of Birth", 2);
                YearB := Date2DMY("Date of Birth", 3);

                Birthday := Format(DayB) + '/' + Format(MonthB);

                DayA := Date2DMY(Today, 1);
                MonthA := Date2DMY(Today, 2);
                YearA := Date2DMY(Today, 3);

                TDay := Format(DayA) + '/' + Format(MonthA);

                if Birthday = TDay then begin
                    if "Mobile Phone No" <> '' then
                        SendSMS.CreateSmsNotif(NotifSource::Other, '', 'Happy Birthday ' + ' ' + Name + ' ' +
                        'Thank you for choosing us : More than credit, we fulfill all your financial needs. Tel:', '', '', false);
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        DayB: Integer;
        MonthB: Integer;
        YearB: Integer;
        DayA: Integer;
        MonthA: Integer;
        YearA: Integer;
        Birthday: Code[50];
        TDay: Code[50];
        SendSMS: Codeunit "SMS Notification";
}




