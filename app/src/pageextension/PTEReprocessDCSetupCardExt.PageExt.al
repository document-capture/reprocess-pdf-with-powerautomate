pageextension 61130 "PTE Reprocess DC Setup CardExt" extends "CDC Document Capture Setup"
{
    layout
    {
        addafter(Numbering)
        {
            group(PdfReprocessing)
            {
                Caption = 'Pdf file reprocessing';

                field("Power Automate Webservice URL"; Rec."Power Automate Webservice URL")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Microsoft Power Automate Webservice that is used to reprocess broken pdf files.';
                }
            }
        }
    }
}
