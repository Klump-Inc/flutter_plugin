final loanPartnersJson = {
  "data": [
    {
      "id": "890557e1-892d-4423-9e95-c6abf08bee01",
      "name": "Polaris Bank",
      "slug": "polaris",
      "logo":
          "https://s3.eu-west-1.amazonaws.com/cdn.useklump.com/bank-logos/polaris.png",
      "is_active": true,
      "requires_prequalification": false,
      "interest": "2.25",
      "min_loan_amount": "50000.00",
      "max_loan_amount": null,
      "min_age": null,
      "config": {
        "create_partner_account_url":
            "https://www.polarisbanklimited.com/open-an-account/",
        "callback_url": "asset.useklump.com/redirect.html?partner=polaris",
        "invoice_number": "UUL"
      },
      "extra_charges": [
        {
          "name": "Management fee",
          "value": "1.5",
          "unit": "%",
          "slug": "management_fee"
        }
      ],
      "created_at": null,
      "updated_at": "2023-10-10T08:07:39.740Z",
      "next_step": {
        "name": "PARTNER_REQUIREMENTS",
        "display_data": {
          "title": "Pay in instalments with Polaris",
          "smalltext":
              "By pressing continue, you consent to Klump sharing billing information with this merchant.",
          "list": [
            {"text": "Your Active Polaris Bank Account Number"},
            {"text": "A valid phone number and email address"}
          ]
        },
        "display_mobile_ux_warning": true,
        "method": "GET",
        "api": "/loans/partners/requirements?partner=polaris"
      }
    },
    {
      "id": "ba550ab4-da01-4101-ba74-c75000223d14",
      "name": "Specta by Sterling Bank",
      "slug": "specta",
      "logo":
          "https://s3.eu-west-1.amazonaws.com/cdn.useklump.com/bank-logos/sterling.png",
      "is_active": true,
      "requires_prequalification": false,
      "interest": null,
      "min_loan_amount": null,
      "max_loan_amount": null,
      "min_age": null,
      "config": {
        "extra_form_fields": [
          {
            "type": "select",
            "name": "bank",
            "label": "Bank",
            "placeholder": "Choose your bank",
            "options": [
              {"name": "Access Bank", "slug": "access_bank"},
              {"name": "Eco Bank", "slug": "ecobank"},
              {"name": "FCMB", "slug": "fcmb"},
              {"name": "Fidelity Bank", "slug": "fidelity"},
              {"name": "First Bank", "slug": "first_bank"},
              {"name": "FSDH Merchant Bank", "slug": "fsdh"},
              {"name": "GT Bank", "slug": "gtb"},
              {"name": "Heritage Bank", "slug": "heritage"},
              {"name": "Keystone Bank", "slug": "keystone"},
              {"name": "Parallex Bank", "slug": "parallex"},
              {"name": "Polaris Bank Limited", "slug": "polaris"},
              {"name": "Providus Bank", "slug": "providus"},
              {"name": "Stanbic IBTC Bank", "slug": "stanbic"},
              {"name": "Sterling Bank", "slug": "specta"},
              {"name": "UBA", "slug": "uba"},
              {"name": "Union Bank", "slug": "union_bank"},
              {"name": "Unity Bank", "slug": "unity_bank"},
              {"name": "VFD MFB", "slug": "vfdmfb"},
              {"name": "Wema Bank", "slug": "wema"},
              {"name": "Zenith Bank", "slug": "zenith"}
            ]
          }
        ]
      },
      "extra_charges": [],
      "created_at": null,
      "updated_at": "2023-09-15T13:48:25.146Z",
      "next_step": {
        "name": "ACCOUNT_VERIFICATION",
        "display_data": {
          "subtitle": "Enter your Specta account details.",
          "create_partner_account_text":
              "Don't have a Specta account? Create one",
          "create_partner_account_url":
              "https://paywithspecta.com/account/register"
        },
        "form_fields": [
          {
            "type": "text",
            "name": "accountNumber",
            "label": "Account Number",
            "placeholder": "Account Number",
            "required": true
          },
          {
            "type": "text",
            "name": "phoneNumber",
            "label": "Phone Number",
            "placeholder": "Enter phone number registered to your bank account",
            "required": true
          }
        ],
        "display_mobile_ux_warning": true,
        "method": "POST",
        "api": "/loans/account/verification"
      }
    },
    {
      "id": "9f90d48d-81f1-488d-86a6-cd41b0599a68",
      "name": "Stanbic IBTC Bank",
      "slug": "stanbic",
      "logo":
          "https://s3.eu-west-1.amazonaws.com/cdn.useklump.com/bank-logos/stanbic.png",
      "is_active": true,
      "requires_prequalification": false,
      "interest": null,
      "min_loan_amount": null,
      "max_loan_amount": null,
      "min_age": null,
      "config": {
        "create_partner_account_url":
            "https://ienroll.stanbicibtc.com:8444/OnlineAccountOnboarding"
      },
      "extra_charges": [],
      "created_at": null,
      "updated_at": "2023-08-11T16:57:51.197Z",
      "next_step": {
        "name": "ACCOUNT_VERIFICATION",
        "display_data": {
          "subtitle": "Login to your Stanbic IBTC account.",
          "create_partner_account_text":
              "Don’t have a Stanbic account? Create one",
          "create_partner_account_url":
              "https://ienroll.stanbicibtc.com:8444/OnlineAccountOnboarding"
        },
        "form_fields": [
          {
            "type": "text",
            "name": "accountNumber",
            "label": "Account Number",
            "placeholder": "Account Number",
            "format": ""
          },
          {
            "type": "text",
            "name": "phoneNumber",
            "label": "Phone Number",
            "placeholder": "Phone number"
          }
        ],
        "method": "POST",
        "api": "/loans/account/verification"
      }
    },
    {
      "id": "484d8a06-377a-4186-a56a-206d5e36a2df",
      "name": "Fidelity Bank (coming soon)",
      "slug": "fidelity",
      "logo":
          "https://s3.eu-west-1.amazonaws.com/cdn.useklump.com/bank-logos/fidelity.png",
      "is_active": false,
      "requires_prequalification": false,
      "interest": null,
      "min_loan_amount": null,
      "max_loan_amount": null,
      "min_age": null,
      "config": {},
      "extra_charges": [],
      "created_at": null,
      "updated_at": "2023-09-14T18:39:25.062Z",
      "next_step": {
        "name": "ACCOUNT_VERIFICATION",
        "form_fields": [
          {
            "type": "text",
            "name": "accountNumber",
            "label": "Account Number",
            "placeholder": "Account Number",
            "required": true,
            "format": ""
          },
          {
            "type": "text",
            "name": "phoneNumber",
            "label": "Phone Number",
            "placeholder": "Phone number",
            "required": true
          }
        ],
        "method": "POST",
        "api": "/loans/account/verification"
      }
    },
    {
      "id": "da18b046-32ff-4120-b936-fd6da748dd14",
      "name": "Wema Bank (coming soon)",
      "slug": "wema",
      "logo":
          "https://s3.eu-west-1.amazonaws.com/cdn.useklump.com/bank-logos/wema.png",
      "is_active": false,
      "requires_prequalification": false,
      "interest": null,
      "min_loan_amount": null,
      "max_loan_amount": null,
      "min_age": null,
      "config": {},
      "extra_charges": [],
      "created_at": null,
      "updated_at": "2023-09-14T17:46:16.065Z",
      "next_step": {
        "name": "ACCOUNT_VERIFICATION",
        "form_fields": [
          {
            "type": "text",
            "name": "accountNumber",
            "label": "Account Number",
            "placeholder": "Account Number",
            "required": true,
            "format": ""
          },
          {
            "type": "text",
            "name": "phoneNumber",
            "label": "Phone Number",
            "placeholder": "Phone number",
            "required": true
          }
        ],
        "method": "POST",
        "api": "/loans/account/verification"
      }
    }
  ]
};

final repaymentDetailsJson = {
  "accountNumber": "1234567890",
  "transactionType": "NEW",
  "instantBuyAmount": 40000,
  "loanAmount": 33333.33,
  "downpaymentAmount": 6666.67,
  "monthlyRepayment": 7174.9,
  "totalRepayment": 35874.5,
  "managementFee": 333.33,
  "interest": 2.5,
  "vat": 25,
  "insurance": 150,
  "tenor": 5,
  "installment": 6,
  "minimumBalanceRequired": 7675,
  "repaymentDay": 7,
  "repaymentSchedules": [
    {
      "principal": 6341.57,
      "interest": 833.33,
      "monthlyRepayment": 7174.9,
      "principalBalance": 26991.77,
      "repayment_date": "Jun 7, 2023"
    },
    {
      "principal": 6500.11,
      "interest": 674.79,
      "monthlyRepayment": 7174.9,
      "principalBalance": 20491.66,
      "repayment_date": "Jul 7, 2023"
    },
    {
      "principal": 6662.61,
      "interest": 512.29,
      "monthlyRepayment": 7174.9,
      "principalBalance": 13829.05,
      "repayment_date": "Aug 7, 2023"
    },
    {
      "principal": 6829.17,
      "interest": 345.73,
      "monthlyRepayment": 7174.9,
      "principalBalance": 6999.88,
      "repayment_date": "Sep 7, 2023"
    },
    {
      "principal": 6999.9,
      "interest": 175,
      "monthlyRepayment": 7174.9,
      "principalBalance": 0,
      "repayment_date": "Oct 7, 2023"
    }
  ],
  "repaymentMetadata": null,
  "other_charges": {}
};

final accountValidationJson = {
  "status": true,
  "message":
      "Account verified. An Otp has been sent to your registered email and phone number for final verification",
  "next_step": {
    "name": "VERIFY_OTP",
    "display_data": {
      "title": "Enter the code",
      "subtitle": "A code has been sent to your email address and phone number"
    },
    "form_fields": [
      {"type": "hidden", "name": "accountNumber", "label": "Account Number"},
      {"type": "hidden", "name": "phoneNumber", "label": "Phone Number"},
      {"type": "hidden", "name": "email", "label": "Email"},
      {
        "type": "text",
        "name": "otp",
        "label": "OTP",
        "placeholder": "Enter the 6-digit code here"
      }
    ],
    "method": "POST",
    "api": "/loans/account/verify-otp"
  }
};
final verifyOTPJson = {
  "status": true,
  "message": "OTP verified successfully.",
  "next_step": {
    "name": "TERM_CONDITIONS",
    "method": "GET",
    "display_data": {
      "title": "Read and agree to the terms of service to continue",
      "version": "1",
      "text":
          "<div style=\"text-align: justify;\">\r\n    <p style=\"text-align: center;\"><strong>Buy Now Pay Later (BNPL) EZ Cash Terms and Conditions</strong></p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>1. Acceptance</strong></p>\r\n    <p>These Terms and Conditions are between Customers (&#8220;you&#8221; &#8220;your&#8221;) and Stanbic IBTC\r\n        Bank PLC (&#8220;Stanbic IBTC&#8221; &#8220;the Bank&#8221;, &#8220;we&#8221; or &#8220;us&#8221;) at the\r\n        time you request for EZ\r\n        Cash loan from Stanbic\r\n        IBTC\r\n        Bank. Stanbic IBTC Bank&rsquo;s EZ Cash loan includes EZ Cash loan accessed via any of Stanbic IBTC&rsquo;s\r\n        digital\r\n        channels\r\n        i.e. Internet Banking, Mobile App, USSD and web channels.</p>\r\n    <p>\r\n        Stanbic IBTC&rsquo;s EZ Cash is a product that forms part of Stanbic IBTC&rsquo;s Digital Lending suite. By\r\n        accessing\r\n        and\r\n        requesting for loans via the aforementioned channels, you hereby agree and consent to be bound by these\r\n        Terms\r\n        and Conditions.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>2. Devices and medium</strong></p>\r\n    <p>\r\n        You may choose to access our EZ Cash on a Computer, Mobile phone, Telephone using VAR (Voice Assistance\r\n        Response), or similar technologies (the device) and the medium through which you access EZ Cash may include\r\n        the Internet, wireless application protocol (WAP), wireless Internet gateway (WIG), short messaging system\r\n        (SMS), voice over an automated voice recognition system or similar technologies (the medium). We will refer\r\n        to the device and the medium collectively as &#8220;the communication system&#8221;. You must take all\r\n        reasonable\r\n        precautions to keep safe and prevent fraudulent use of your devices and security information. These\r\n        precautions include never writing down or otherwise recording your security details such a Transaction\r\n        authorization, Personal Identification Number (PIN),Access codes and One time passwords in a way that can be\r\n        understood by someone else; not choosing security details that may be easy to guess; taking care to ensure\r\n        that no one hears or sees your security details when you use it; not disclosing your security details to\r\n        anyone, including us; changing your security details immediately and telling us as soon as possible if you\r\n        know, or even suspect, that someone else knows your security details; keeping your security details and\r\n        device safe; complying with all reasonable instructions we issue regarding keeping your security details\r\n        safe; and undertake reasonable and adequate safeguards to scan for computer viruses or other destructive\r\n        properties.\r\n    </p>\r\n    <p>\r\n        We will not be liable for any instruction given by you or anyone acting with your authority from the moment\r\n        you access/use EZ Cash. You are responsible for making sure information shown or stored on mobile device is\r\n        kept secure. You must advise us of any change to your mobile phone number without delay.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>3. Amendments</strong></p>\r\n    <p>The terms and conditions may be amended/varied from time to time and you are bound by the version of the\r\n        terms and conditions that exists at the time you access EZ Cash. EZ CashTerms and Conditions shall be\r\n        available on Stanbic IBTC Bank&rsquo;s website, Mobile banking platform and USSD banking platform.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>4. Interest and Fees</strong></p>\r\n    <p>For the use of EZ Cash, customers will be charged the following:</p>\r\n    <ol>\r\n        <li>The interest rate for this term loan is 2.5% flat per month.</li>\r\n        <li>This term loan will attract a management fee of 1% on the amount borrowed and a 7.5% value added tax\r\n            (VAT) deduction on the fee charged.</li>\r\n        <li>For personal banking customers, an insurance premium on the loan amount will be charged as 0.45% for 6 months and insurance company selected by the Borrower</li>\r\n        <li>A late repayment fee of 1% flat per month, shall be applied on the outstanding unpaid obligation without\r\n            recourse to the borrower.</li>\r\n        <li>The interest rate applicable to the loan is initially determined by the Bank and will be disclosed to\r\n            the Borrower in writing or electronically.</li>\r\n        <li>If the Borrower&rsquo;s use of the loan exceeds the arranged limit, interest will be charged on the\r\n            excess\r\n            amount at a rate above the interest rate in 4.1 above but not exceeding the legal maximum permissible\r\n            rate.</li>\r\n        <li>The interest payable by the Borrower is:\r\n            <ol>\r\n                <li>Calculated on a daily basis on the outstanding balance owing on the Borrower&rsquo;s loan;</li>\r\n                <li>Calculated a 365-day year, irrespective of whether the year in question is a leap year;</li>\r\n                <li>debited to the Borrower&rsquo;s account held with the Bank monthly in arrears, notwithstanding\r\n                    that\r\n                    such balance may have been increased by the debiting of interest to such balance, and is due and\r\n                    payable immediately.</li>\r\n            </ol>\r\n        </li>\r\n        <li>The Bank may, from time to time, upon 10 (ten) business days prior written notice to the Borrower vary\r\n            the\r\n            pricing applicable to the Loan and the method of calculating it during the agreed term of the Loan\r\n            subject to\r\n            changes in CBN regulations and money market conditions. Such changes will be communicated either\r\n            directly to the\r\n            Borrower or via a general notice to all Borrowers of the Bank. If the Bank elects to advise such\r\n            change(s)\r\n            directly to the Borrower, the Bank&rsquo;s advice will take the form of a letter or SMS</li>\r\n    </ol>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>6. Use of EZ Cash </strong></p>\r\n    <p>You can access and use EZ Cash service on Internet Banking, Mobile App, Web or USSD channels to request for\r\n        EZ Cash loans. We will act on instructions that appear to have been sent by you</p>\r\n    <p>Use of a communication system means we do not interact face-to-face. Unless you notify us before we give\r\n        effect to an instruction, you authorize us to rely on and perform all instructions that appear to originate\r\n        from you (even if someone else is impersonating you).</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>7. Your authority</strong></p>\r\n    <p>You permit us to regard all activities you conduct, or instructions sent when you request for EZ Cash as\r\n        being authorized by you and intended to have legal force and effect.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>8. Sufficient notice</strong></p>\r\n    <p>You permit us to issue notices required in terms of these Terms & Conditions, legislation or regulation by\r\n        making such notification available via our communication systems or sending such notification by email, SMS\r\n        or similar future technologies. Any notices so issued by us, will as far as they contain contractual terms\r\n        relating to EZ Cash, also form part of these Terms and Conditions.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>9. Nature of information on the communication system</strong></p>\r\n    <p>Information on the communication system is intended to provide you with only general information about the\r\n        bank, its products, services and objectives. From time to time we may provide information on:</p>\r\n    <p>a. projected revenues, income, earnings per share, capital expenditures, dividends, capital structure or\r\n        other financial items;</p>\r\n    <p>b. our plans, objectives and projections for future operations and service</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>10. Transmission of information and security tips</strong></p>\r\n    <p>Information transmitted via an unsecured link over a communication system is susceptible to potential\r\n        unlawful access, distortion or monitoring. You must comply with the security tips which are published on our\r\n        website from time to time. As we do not have the ability to prevent unlawful activities by unscrupulous\r\n        persons, you accept that we cannot be held liable for any loss, harm or damage suffered by you as a result\r\n        thereof. To limit these risks, we may request independent verification of any information transmitted by you\r\n        via our communication system from time to time.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>11. Indemnity</strong></p>\r\n    <p>You shall indemnify us for all losses and costs we may incur on your behalf due to your non-payment; any\r\n        instruction exceeding the amount available in your bank account; or unauthorised instructions executed which\r\n        were not due to our negligence</p>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>12. Unavailability of EZ Cash Services</strong></p>\r\n    <p>We will at all times and for whatever reason, have the sole and exclusive right to suspend or terminate EZ\r\n        Cash without any prior notification or giving any reasons for such termination or suspension. You\r\n        acknowledge and accept that EZ Cash banking services may be unavailable from time to time for any reason,\r\n        including: technical failure or problems with the communication system itself or our communication system\r\n        underlying banking systems (the bank system); technical failure or problems with any systems directly or\r\n        indirectly underlying EZ Cash transactional services that are owned or controlled by third parties;\r\n        unavailability of telecommunication or electricity services; or other circumstances beyond our control . You\r\n        undertake, in the event of unavailability of EZ Cash services, to limit potential errors/losses by using any\r\n        other means of Banking with us for the duration of the unavailability of EZ Cash banking services.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>13. Warranties and representations</strong></p>\r\n    <p>\r\n        We do not expressly warrant that EZ Cash services will be error-free or will meet any particular criteria of\r\n        accuracy, completeness or reliability of information, performance or quality. We expressly disclaim all\r\n        implied warranties, including, without limitation, warranties of merchantability, title, fitness for a\r\n        particular purpose, non-infringement, compatibility, security and accuracy.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>14. Disclaimer and limitation of liability</strong></p>\r\n    <p>\r\n        For purposes of this clause, the Bank as well as other Stanbic IBTC entities, its affiliates, shareholders,\r\n        employees, consultants and agents. Although taking sufficient care to ensure that the content provided on\r\n        the communication system is accurate and that you suffer no loss or damage as a result of you using the\r\n        content on the communication system and EZ Cash services are provided &#8220;as is&#8221;. We are not liable\r\n        for\r\n        any\r\n        damages whatsoever relating to your use of EZ Cash services on the communication system. This includes the\r\n        information contained on the communication system or your inability to use the communication system or EZ\r\n        Cash services, including, without limitation, any direct, indirect, special, incidental or consequential\r\n        damages, whether arising out of contract, statute, delict or otherwise and regardless of whether we were\r\n        expressly advised of the possibility of such loss or damage. Without derogating from the generality of the\r\n        foregoing, we are not liable for:\r\n    </p>\r\n    <p>a. any damages which you suffer as a result of a compromise of your access codes.</p>\r\n    <p>b. any interruption, malfunction, downtime or other failure of the communication system or EZ Cash service,\r\n        our banking system, third party system, databases or any component part thereof for whatever reason.</p>\r\n    <p>c. any loss or damage which arises from your transactions, instructions, orders, investment decisions,\r\n        purchases or disposal of goods and services, including financial instruments or currencies, from third\r\n        parties based upon the information provided on the communication system.</p>\r\n    <p>d. any loss or damage with regard to your or any other data directly or indirectly caused by malfunction of\r\n        our bank system, third party systems, power failures, unlawful access to or theft of data, computer viruses\r\n        or destructive code on the bank system or third-party systems; programming defects, negligence on our part.\r\n    </p>\r\n    <p>e. any interruption, malfunction, downtime or other failure of goods or services provided by third parties,\r\n        including, without limitation, third party systems such as the public switched telecommunication service\r\n        providers, internet service providers, electricity and water suppliers, local authorities and certification\r\n        authorities</p>\r\n    <p>f. any event over which we have no direct control.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>15. Breach</strong></p>\r\n    <p>We may terminate your access to EZ Cash services if you breach a material term of these terms and conditions\r\n        and fail to remedy it within five days of you being notified by us. We may do this without detracting from\r\n        our right to take any other steps available to us at law or under these Terms & Conditions. If you have\r\n        consistently breached any of these Terms and Conditions including where; you are, or we reasonably suspect\r\n        you may be, using or obtaining, or allowing someone else to use an account or receive services or money\r\n        illegally; or your account is, or we reasonably suspect your account is, being used for an illegal or\r\n        fraudulent purpose; or we have reasonable grounds to suspect fraudulent use of your security details; or we\r\n        have reasonable grounds for believing you have committed or are about to commit a crime in connection with\r\n        your account; or you have not satisfied any anti-money laundering requirements or there has been or we\r\n        suspect there has been fraud involving any of your accounts with us; or If there has been or we suspect\r\n        there has been suspicious activity on your account; or If you stop holding any account, product or service\r\n        in respect of which the EZ Cash Services may be used.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>16. Capacity to enter into these Terms & Conditions</strong></p>\r\n    <p>You warrant to us that you have the required legal capacity to agree and be bound by these terms and\r\n        conditions. Anyone below the age of 18 must be assisted by their legal guardian when reading this these\r\n        Terms & Conditions. If you are below 18 years of age you have to speak to your legal guardian or parents. If\r\n        you are unsure whether you have the legal capacity to enter into contractual agreements/ these Terms &\r\n        Conditions., please contact our Customer Contact Centre for assistance before you start or continue to use\r\n        EZ Cash Services.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>17. Contact details /address for notices </strong></p>\r\n    <p>For the purpose of service of any legal process we choose the following registered address: E-Business\r\n        Department, Stanbic IBTC Bank PLC, IBTC Place, Walter Carrington Crescent, Victoria Island, Lagos.</p>\r\n\r\n    <div style=\"margin-left: 24px;\">\r\n        <p style=\"text-align: justify;\"><strong>For Complaint or Query Management</strong></p>\r\n        <p>Do not hesitate to reach out to your lender through the following</p>\r\n        <p>\r\n            Telephone: +234 1 422 2222<br>\r\n            Address: The IBTC Place, Walter Carrington Crescent, Victoria Island, Lagos<br>\r\n            Email: <span\r\n                style=\"text-decoration: underline;color: blue;\">customercarenigeria@stanbicibtc.com</span><br>\r\n        </p>\r\n    </div>\r\n    <p>If dissatisfied with the resolution of your complaint, you may escalate the complaint to the Consumer\r\n        Protection Department of the Central Bank of Nigeria by writing to the Director, Consumer Protection\r\n        Department, CBN, Abuja or send an email to:<span\r\n            style=\"text-decoration: underline;color: blue;\">cpd@cbn.gov.ng.</span></p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>18. Law that applies to the Terms and Conditions</strong></p>\r\n    <p>The EZ Cash Services Terms and Conditions will be governed and construed in accordance with the Federal\r\n        Republic of Nigeria without reference to any conflict of law provisions, and any dispute arising therefrom\r\n        shall be determined in accordance with such laws. Except stated otherwise, all copyright in the\r\n        communication systems is owned by or licensed to us or members of Stanbic IBTC Group.</p>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>19. General provisions</strong></p>\r\n    <p>No failure or delay by us to exercise any of our rights is to be construed as a waiver of any such right,\r\n        whether this is done expressly or is implied. It will also not affect the validity of any part of these\r\n        conditions or prejudice our right to take subsequent action against you.</p>\r\n\r\n    <p>If any of these terms, conditions or provisions are held to be invalid, unlawful or unenforceable to any\r\n        extent; such term, condition or provision will be severed from the remaining terms, conditions and\r\n        provisions, which will continue to be valid to the full extent permitted by law. </p>\r\n    <p>If you have any questions about this terms and conditions or do not understand anything in these Terms &\r\n        Conditions, please call our Customer Care Centre 0700 909 909 909\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>20. Payments</strong></p>\r\n    <p>1. All payments by the Borrower under the Loan, whether of principal, interest, fees, costs or otherwise,\r\n        shall be made in full in immediately available funds, without set-off or counterclaim and free and clear of\r\n        any deduction or withholding on account of tax or otherwise.</p>\r\n    <p>2. If the Borrower is required by law to make any deduction or withholding from any payment under the Loan,\r\n        the sum due from the Borrower in respect of such payment shall be increased to the extent necessary to\r\n        ensure that, after the making of such deduction or withholding, the Bank receives a net sum equal to the sum\r\n        which it would have received had no such deduction or withholding been required.</p>\r\n    <p>\r\n        3. If a repayment in terms of this Term Loan falls due on a date, which is not a Business day (being a day\r\n        which is a Saturday, Sunday or official public holiday in Nigeria), then such repayment shall be made on the\r\n        due date\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>21. Confidential Information</strong></p>\r\n    <ol>\r\n        <li>\r\n            The Borrower hereby consents that the Bank may: -\r\n            <ol>\r\n                <li>hold and process, by computer or otherwise, any information obtained about the Borrower as a\r\n                    consequence of the Facilities contemplated in this Letter;</li>\r\n                <li>include personal data in the Bank&rsquo;s systems which may be accessed by other companies in\r\n                    the\r\n                    Bank&rsquo;s group for credit assessment, statistical analysis including behavior and scoring\r\n                    and to\r\n                    identify products and services (including those supplied by third parties) which may be relevant\r\n                    to the Borrower; and</li>\r\n                <li>permit other companies within the Bank&rsquo;s group to use personal data and any other\r\n                    information it\r\n                    holds about the Borrower to bring to its attention products and services which may be of\r\n                    interest to the Borrower.</li>\r\n            </ol>\r\n        </li>\r\n        <li>\r\n            The Borrower further consents that the Bank may disclose its personal data and/or information relating\r\n            to the Borrower including data and information relating to this Letter and any documents referred to\r\n            herein or the assets, business or affairs of the Borrower outside the Bank&rsquo;s group whether such\r\n            personal\r\n            data and/or information is obtained after the Borrower ceases to be the Bank&rsquo;s Borrower or during\r\n            the\r\n            continuance of the banker-Borrower relationship or before such relationship was in contemplation:\r\n            <ol>\r\n                <li>for fraud prevention purposes;</li>\r\n                <li>to licensed credit reference agencies or any other creditor, if the Borrower is in breach of\r\n                    this Loan Letter or any documents referred to herein;</li>\r\n                <li>to its external lawyers, auditors and other sub-contractors or persons acting as the\r\n                    Bank&rsquo;s\r\n                    agents;</li>\r\n                <li>to any person who may assume the Bank&rsquo;s rights under this Loan Letter;</li>\r\n                <li>if the Bank has a right or duty to disclose or are permitted or compelled to do so by law; and\r\n                </li>\r\n                <li>for the purpose of exercising any power, remedy, right, authority, or discretion relevant to\r\n                    this Loan Letter or any other document.</li>\r\n            </ol>\r\n        </li>\r\n        <li>\r\n            The Borrower acknowledges and agrees that, notwithstanding the terms of any other agreement between the\r\n            Borrower and the Bank, a disclosure of information by the Bank in the circumstances contemplated by this\r\n            clause does not violate any duty owed to the Borrower either in common law or pursuant to any agreement\r\n            between the Bank and the Borrower or in the ordinary course of banking business and the customs, usage\r\n            and practice related thereto and further that disclosure as aforesaid may be made without reference to\r\n            or further authority from the Borrower and without inquiry by the Bank as to the justification for or\r\n            validity of such disclosure.\r\n        </li>\r\n    </ol>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>22. Cross Default</strong></p>\r\n    <p>Default in respect of any other financial obligation or shall render the Borrower default.\r\n        &lsquo;Default&rsquo; in this\r\n        context shall include, but not be limited to, any irregular conduct of an account, non-compliance with the\r\n        legal and regulatory requirements of Nigeria or violation of its corporate governance principles.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>Environmental & Social Responsibility</strong></p>\r\n\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">23.1</span>\r\n            The Borrower warrants and represents to the Bank that it is in full compliance with all applicable laws,\r\n            regulations and practices relating to the protection of the environment and its social responsibility\r\n            applicable to it in each jurisdiction in which the Borrower conducts business (its &#8220;Environmental &\r\n            Social\r\n            Responsibility&#8221;) and hereby undertake to continue to do so for so long as the Borrower is indebted to\r\n            or\r\n            owes any obligations to the Bank.\r\n        </div>\r\n    </p>\r\n\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">23.2</span>\r\n            The Borrower warrants that it is not aware of any circumstances which may prevent full compliance with\r\n            its Environmental & Social Responsibility in future\r\n        </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">23.3</span>\r\n        The Borrower hereby indemnifies the Bank against any loss, damage, claims, costs or any other\r\n        liability, which may arise (because of this or any other banking facility and/or the Bank having an interest\r\n        in any of the Borrower&rsquo;s assets) in respect of a breach of, or a failure by the Borrower to meet its\r\n        Environmental & Social Responsibilities.\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">23.3</span>\r\n            The Borrower undertakes to notify the Bank in the event of material Environmental & Social incidents\r\n            which include contamination, strikes, protests, lawsuits, claims or media coverage of Environmental & Social\r\n            concerns, or suspension or withdrawal of E&S permits.\r\n        </div>\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>24. Sanctions</strong></p>\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">24.1</span>\r\n            The Borrower/Customer declares warrants, represents and undertakes to the Bank on the\r\n            date of signature hereof and on each date upon which a facility is utilized that:\r\n        </div>\r\n    </p>\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">24.1.1</span>\r\n            He/She/it will not use or make available the proceeds of any of the Facilities for the\r\n            purposes of\r\n            financing, directly or indirectly, the activities, business or transactions of any entity or person or\r\n            subsidiary or affiliate which is Sanctioned or in a country which is subject to any Sanctions\r\n        </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.1.2</span>\r\n        He/She/it will not contribute or otherwise make available, directly or indirectly, the proceeds of\r\n        any of the Facilities to any other entity, person, affiliate or subsidiary, or if such party uses or intends\r\n        to use such proceeds for the purpose of financing the activities of any person or entity which is subject to\r\n        any Sanctions;\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.1.3</span>\r\n        He/She/it is not involved in any illegal or terrorist activities; and\r\n    </div>\r\n    </p>\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.1.4</span>\r\n        none of its bank accounts held with the Bank are being used fraudulently, negligently, for illegal or\r\n        terrorist activities, or for any purpose that does not comply with any law.\r\n    </div>\r\n    </p>\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.2</span>\r\n        The Borrower/Customer hereby indemnifies and holds the Bank and/or any Bank Related Entity (Bank\r\n        Related Entity shall mean Standard Bank Group Limited or any other Subsidiary or associate company of\r\n        Standard Bank Group Limited) harmless against any actions, proceedings, claims and/or demands that may be\r\n        brought against the Bank and/or Bank Related Entity and all losses, damages, costs and expenses which the\r\n        Bank and/or Bank Related Entity may incur or sustain, in connection with or arising out of\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.2.1</span>\r\n        the seizure, blocking or withholding of any funds by any Sanctioning Body; and\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.2.2</span>\r\n        the breach of any warranties as set out in paragraphs above.\r\n        Payment under the above indemnity shall be made by the Borrower/Customer on demand by the Bank or such other\r\n        Bank Related Entity\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3</span>\r\n        Definitions\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.1</span>\r\n        &#8220;Sanction List&#8221; shall mean the Specially Designated Nationals and Blocked Persons List of OFAC\r\n        and/or\r\n        the UNSC list of persons or entities suspected to be involved in terrorist related activities or the funding\r\n        thereof and/or any other list of HMT and/or EU\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.2</span>\r\n        &#8220;Sanctioned&#8221; shall mean listed on all or any one of the Sanction Lists and/or subject to any\r\n        Sanctions.\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3</span>\r\n        &#8220;Sanctions&#8221; shall mean the economic sanctions, laws, regulations, embargoes or restrictive\r\n        measures\r\n        administered, enacted or enforced by any one of the following regimes (each a &#8220;Sanctioning\r\n        Body&#8221;):the\r\n        United\r\n        States Government;\r\n    </div>\r\n    </p>\r\n\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.1</span>\r\n        the United Nations;\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.2</span>\r\n        the European Union;\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.3</span>\r\n        the United Kingdom; or\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.4</span>\r\n        the respective governmental institutions and agencies of any of the foregoing, including without\r\n        limitation, the Office of Foreign Assets Control of the Department of Treasury of the United States of\r\n        America (&#8220;OFAC&#8221;) or the United Nations Security Council (&#8220;UNSC&#8221;) or Her\r\n        Majesty&rsquo;s Treasury\r\n        of the\r\n        United\r\n        Kingdom (&#8220;HMT&#8221;) or the European Union&rsquo;s Common Foreign and Security Policy\r\n        (&#8220;EU&#8221;).\r\n    </div>\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>25. MLPA, AML/CFT Requirements </strong></p>\r\n    <p>\r\n        The Borrower acknowledges that the Bank is obliged to comply with the Money Laundering (Prohibition) Act\r\n        (MLPA) 2011 (as amended) and Central Bank of Nigeria Anti-Money Laundering/Combating of Financing of\r\n        Terrorism (AML/CFT) Regulation, 2009 (as amended), and undertakes to provide such information and documents\r\n        as the Bank may, from time to time request in order to comply with such MLPA and AML/CFT requirements\r\n        including information and documents of the Borrower from time to time.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>26. Global Standing Instruction</strong></p>\r\n    <p>\r\n        By accepting this loan offer and by drawing on the loan, I covenant to repay the loan as and when due. In\r\n        the event that I fail to repay the loan as agreed, and the loan becomes delinquent, the bank shall have the\r\n        right to report the delinquent loan to CBN through the Credit Risk Management System (CRMS) or by any other\r\n        means, and request the CBN to exercise its regulatory power to direct all banks and other financial\r\n        institutions under its regulatory purview to set-off my indebtedness from any money standing to my credit in\r\n        any bank account and from any other financial assets they may be holding for my benefit.\r\n    </p>\r\n    <p>\r\n        I covenant and warrant that the CBN shall have power to set-off my indebtedness under this loan agreement\r\n        from all such monies and funds standing to my credit/benefit in any and all such accounts or from any other\r\n        financial assets belonging to me and in the custody of any such bank.\r\n    </p>\r\n    <p>\r\n        I hereby waive any right of confidentiality whether arising under common law or statute or in any other\r\n        manner whatsoever and irrevocably agree that I shall not argue to the contrary before any court of law,\r\n        tribunal, administrative authority or any other body acting in any judicial or quasi-judicial capacity.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>27. Credit Guarantee (for Business Customers only)</strong></p>\r\n    <p>\r\n        I / We hereby consent and authorize the Bank to guarantee the credit facilities with any of the licenced Credit Guarantee Companies in Nigeria  and hereby confirm that I / We have sought and obtained independent professional advise and hence do not have any objections to the Bank guaranteeing my / our credit facilities with the Credit Guarantee Companies in Nigeria.\r\n    </p>\r\n</div>"
    },
    "api": "/loans/partners/terms-and-conditions?partner=stanbic"
  },
  "data": {
    "token":
        "eyJhbGciOiJIUzM4NCIsInR5cCI6IkpXVCJ9.eyJqd3RVc2VyIjp7ImlkIjoiNWIwMDI5YTQtYmZmNy00MWUwLWE2NjgtMTU0NjM5ZDQ4YThhIiwiZmlyc3RuYW1lIjoiU3RhbmJpYyIsImxhc3RuYW1lIjoiVXNlciIsImVtYWlsIjoidGVtaWJhbWlAZ21haWwuY29tIiwicGhvbmUiOiIrMjM0ODAxMjM0NTY3OCIsInBhc3N3b3JkIjoiJDJiJDEwJE9YWHc5NkJsOENBeG4wVTYzQUc2SU9mZDdvdnA2WlpOeDBMT2RrRXFmZm1zMFJnOW5FeTNLIiwiZGF0ZV9vZl9iaXJ0aCI6IjE5OTAtMTEtMTFUMDA6MDA6MDAuMDAwWiIsImFjdGl2ZSI6dHJ1ZSwiaXNfZGVsZXRlZCI6ZmFsc2UsImlzXzJmYV92ZXJpZmllZCI6ZmFsc2UsInR3b19mYV9zZWNyZXQiOm51bGwsImlzXzJmYV9lbmFibGVkIjpmYWxzZSwiaXNfYmlvbWV0cmljX2xvZ2luX2VuYWJsZWQiOmZhbHNlLCJpc19lbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNfcGhvbmVfdmVyaWZpZWQiOmZhbHNlLCJwbGF5ZXJfaWQiOm51bGwsImNvZGUiOm51bGwsImF2YXRhciI6Imh0dHBzOi8vczMuZXUtd2VzdC0xLmFtYXpvbmF3cy5jb20vc3RhZ2luZ2Nkbi51c2VrbHVtcC5jb20vcGFzc3BvcnQtcGhvdG9ncmFwaC8xNjkyMzU2MzI1ODY2X3Bhc3Nwb3J0LXBob3RvZ3JhcGgucG5nIiwiZGV2aWNlX2JyYW5kIjpudWxsLCJkZXZpY2VfbW9kZWwiOm51bGwsImRldmljZV9vcyI6bnVsbCwiY3JlYXRlZF9hdCI6IjIwMjMtMDgtMTVUMTU6NTc6NDIuNzkzWiIsInVwZGF0ZWRfYXQiOiIyMDIzLTEwLTExVDExOjMxOjU5LjEwNloiLCJkZWxldGVkX2F0IjpudWxsLCJhZGRyZXNzIjpudWxsLCJhcGFydG1lbnQiOm51bGwsImNpdHkiOm51bGwsInN0YXRlIjpudWxsLCJtb25vX2FjY291bnRfaWQiOm51bGwsInJvbGUiOiJ1c2VyIiwiYnZuIjoiYzA5MjNlZmNmN2M4MzdjOTU1ZTE1MjgxOGRhMTc1MDM6NmUyZjVlNmU5YmIzYjU5NzNjMmMzNTJkNjUzMDk3OGQiLCJhY2NvdW50X251bWJlciI6IjEyMzQ1Njc4OTAiLCJsYXN0X2xvZ2luX2lwIjoiMjAuMTY4LjE1OC4xNzEiLCJsb2FuX2tleSI6bnVsbCwic2lnbnVwX2NoYW5uZWwiOiJzdGFuYmljIiwicmVjb21tZW5kZWRfbG9hbl9hbW91bnQiOiI1MDAwMDAwLjAwIiwiZGV2aWNlX2lkIjpudWxsLCJyZXFJZCI6InRRRHhUbzN2MDFyIiwidXNlcl9pZCI6IjViMDAyOWE0LWJmZjctNDFlMC1hNjY4LTE1NDYzOWQ0OGE4YSIsInBhcnRuZXIiOiJzdGFuYmljIiwiYWNjZXNzX3Rva2VuIjoiZXlKaGJHY2lPaUpJVXpJMU5pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmxiV0ZwYkNJNklpSXNJbkp2YkdVaU9pSlZVMFZTSWl3aVVHaHZibVZPZFcxaVpYSWlPaUlyTWpNMEtEQXBPREF4TWpNME5UWTNPQ0lzSWtGalkyOTFiblJPZFcxaVpYSWlPaUl4TWpNME5UWTNPRGt3SWl3aVFuWnVJam9pTVRJek5EVTJOemc1TURFaUxDSkRhV1pwWkNJNklqRXdNelF4TkRBM09TSXNJa0Z3YVV0bGVTSTZJbEJMWDJKRFpHVkdSMmhKYW10TVRVNXZjRkZ5SWl3aWJtSm1Jam94TmpZNE1UYzBNVFkxTENKbGVIQWlPakUyTmpnek9UQXhOalVzSW1saGRDSTZNVFkyT0RFM05ERTJOWDAuWElQR1pCN3JVUUdSX2NaTThMUEZ0R0F1bUpPVTVuNjNKWnNrbEw4aEhJZyIsImxvZ2dlZEluRW52Ijoic3RhZ2luZyJ9LCJpYXQiOjE2OTcwMjM5MTksImV4cCI6MTY5NzAyNTcxOSwiYXVkIjoiaHR0cHM6Ly9zdGFnaW5nLWFwaS51c2VrbHVtcC5jb20vdjEiLCJpc3MiOiJLbHVtcCJ9.yta-iccjAx69Co38LCVGNyFrLCawXzb_qxgwyt-wssBHlc0f7M-oS9qZRL4M89A9",
    "user": {
      "id": "5b0029a4-bff7-41e0-a668-154639d48a8a",
      "firstname": "Stanbic",
      "lastname": "User",
      "email": "temibami@gmail.com",
      "phone": "+2348012345678",
      "date_of_birth": "1990-11-11T00:00:00.000Z",
      "active": true,
      "is_deleted": false,
      "is_2fa_verified": false,
      "two_fa_secret": null,
      "is_2fa_enabled": false,
      "is_biometric_login_enabled": false,
      "is_email_verified": true,
      "is_phone_verified": false,
      "player_id": null,
      "avatar":
          "https://s3.eu-west-1.amazonaws.com/stagingcdn.useklump.com/passport-photograph/1692356325866_passport-photograph.png",
      "device_brand": null,
      "device_model": null,
      "device_os": null,
      "created_at": "2023-08-15T15:57:42.793Z",
      "updated_at": "2023-10-11T11:31:59.106Z",
      "deleted_at": null,
      "address": null,
      "apartment": null,
      "city": null,
      "state": null,
      "mono_account_id": null,
      "role": "user",
      "bvn":
          "c0923efcf7c837c955e152818da17503:6e2f5e6e9bb3b5973c2c352d6530978d",
      "account_number": "1234567890",
      "last_login_ip": "20.168.158.171",
      "loan_key": null,
      "signup_channel": "stanbic",
      "recommended_loan_amount": "5000000.00",
      "device_id": null
    },
    "loanLimit": 5000000,
    "requiresUserCredential": false
  }
};

final acceptTermsJson = {
  "status": true,
  "message": "Successfully retrieved terms and conditions",
  "next_step": {
    "name": "LOAN_OPTIONS",
    "display_data": {"title": "Your installment split"},
    "form_fields": [
      {
        "type": "select",
        "name": "installment",
        "label": "How would you like to split your payment?",
        "placeholder": "Choose split",
        "options": [
          {"value": 1, "label": "1 instalment"},
          {"value": 2, "label": "2 instalments"},
          {"value": 3, "label": "3 instalments"},
          {"value": 4, "label": "4 instalments"}
        ]
      },
      {
        "type": "select",
        "name": "repaymentDay",
        "label": "Repayment day",
        "options": [
          {"value": 1, "label": 1},
          {"value": 2, "label": 2},
          {"value": 3, "label": 3},
          {"value": 4, "label": 4},
          {"value": 5, "label": 5},
          {"value": 6, "label": 6},
          {"value": 7, "label": 7},
          {"value": 8, "label": 8},
          {"value": 9, "label": 9},
          {"value": 10, "label": 10},
          {"value": 11, "label": 11},
          {"value": 12, "label": 12},
          {"value": 13, "label": 13},
          {"value": 14, "label": 14},
          {"value": 15, "label": 15},
          {"value": 16, "label": 16},
          {"value": 17, "label": 17},
          {"value": 18, "label": 18},
          {"value": 19, "label": 19},
          {"value": 20, "label": 20},
          {"value": 21, "label": 21},
          {"value": 22, "label": 22},
          {"value": 23, "label": 23},
          {"value": 24, "label": 24},
          {"value": 25, "label": 25},
          {"value": 26, "label": 26},
          {"value": 27, "label": 27},
          {"value": 28, "label": 28},
          {"value": 29, "label": 29},
          {"value": 30, "label": 30},
          {"value": 31, "label": 31}
        ]
      },
      {"type": "hidden", "name": "amount"},
      {"type": "hidden", "name": "klump_public_key"},
      {"type": "hidden", "name": "insurerId"}
    ],
    "method": "POST",
    "api": "/loans/account/repayments-detail"
  },
  "data": {
    "title": "Read and agree to the terms of service to continue",
    "version": "1",
    "text":
        "<div style=\"text-align: justify;\">\r\n    <p style=\"text-align: center;\"><strong>Buy Now Pay Later (BNPL) EZ Cash Terms and Conditions</strong></p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>1. Acceptance</strong></p>\r\n    <p>These Terms and Conditions are between Customers (&#8220;you&#8221; &#8220;your&#8221;) and Stanbic IBTC\r\n        Bank PLC (&#8220;Stanbic IBTC&#8221; &#8220;the Bank&#8221;, &#8220;we&#8221; or &#8220;us&#8221;) at the\r\n        time you request for EZ\r\n        Cash loan from Stanbic\r\n        IBTC\r\n        Bank. Stanbic IBTC Bank&rsquo;s EZ Cash loan includes EZ Cash loan accessed via any of Stanbic IBTC&rsquo;s\r\n        digital\r\n        channels\r\n        i.e. Internet Banking, Mobile App, USSD and web channels.</p>\r\n    <p>\r\n        Stanbic IBTC&rsquo;s EZ Cash is a product that forms part of Stanbic IBTC&rsquo;s Digital Lending suite. By\r\n        accessing\r\n        and\r\n        requesting for loans via the aforementioned channels, you hereby agree and consent to be bound by these\r\n        Terms\r\n        and Conditions.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>2. Devices and medium</strong></p>\r\n    <p>\r\n        You may choose to access our EZ Cash on a Computer, Mobile phone, Telephone using VAR (Voice Assistance\r\n        Response), or similar technologies (the device) and the medium through which you access EZ Cash may include\r\n        the Internet, wireless application protocol (WAP), wireless Internet gateway (WIG), short messaging system\r\n        (SMS), voice over an automated voice recognition system or similar technologies (the medium). We will refer\r\n        to the device and the medium collectively as &#8220;the communication system&#8221;. You must take all\r\n        reasonable\r\n        precautions to keep safe and prevent fraudulent use of your devices and security information. These\r\n        precautions include never writing down or otherwise recording your security details such a Transaction\r\n        authorization, Personal Identification Number (PIN),Access codes and One time passwords in a way that can be\r\n        understood by someone else; not choosing security details that may be easy to guess; taking care to ensure\r\n        that no one hears or sees your security details when you use it; not disclosing your security details to\r\n        anyone, including us; changing your security details immediately and telling us as soon as possible if you\r\n        know, or even suspect, that someone else knows your security details; keeping your security details and\r\n        device safe; complying with all reasonable instructions we issue regarding keeping your security details\r\n        safe; and undertake reasonable and adequate safeguards to scan for computer viruses or other destructive\r\n        properties.\r\n    </p>\r\n    <p>\r\n        We will not be liable for any instruction given by you or anyone acting with your authority from the moment\r\n        you access/use EZ Cash. You are responsible for making sure information shown or stored on mobile device is\r\n        kept secure. You must advise us of any change to your mobile phone number without delay.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>3. Amendments</strong></p>\r\n    <p>The terms and conditions may be amended/varied from time to time and you are bound by the version of the\r\n        terms and conditions that exists at the time you access EZ Cash. EZ CashTerms and Conditions shall be\r\n        available on Stanbic IBTC Bank&rsquo;s website, Mobile banking platform and USSD banking platform.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>4. Interest and Fees</strong></p>\r\n    <p>For the use of EZ Cash, customers will be charged the following:</p>\r\n    <ol>\r\n        <li>The interest rate for this term loan is 2.5% flat per month.</li>\r\n        <li>This term loan will attract a management fee of 1% on the amount borrowed and a 7.5% value added tax\r\n            (VAT) deduction on the fee charged.</li>\r\n        <li>For personal banking customers, an insurance premium on the loan amount will be charged as 0.45% for 6 months and insurance company selected by the Borrower</li>\r\n        <li>A late repayment fee of 1% flat per month, shall be applied on the outstanding unpaid obligation without\r\n            recourse to the borrower.</li>\r\n        <li>The interest rate applicable to the loan is initially determined by the Bank and will be disclosed to\r\n            the Borrower in writing or electronically.</li>\r\n        <li>If the Borrower&rsquo;s use of the loan exceeds the arranged limit, interest will be charged on the\r\n            excess\r\n            amount at a rate above the interest rate in 4.1 above but not exceeding the legal maximum permissible\r\n            rate.</li>\r\n        <li>The interest payable by the Borrower is:\r\n            <ol>\r\n                <li>Calculated on a daily basis on the outstanding balance owing on the Borrower&rsquo;s loan;</li>\r\n                <li>Calculated a 365-day year, irrespective of whether the year in question is a leap year;</li>\r\n                <li>debited to the Borrower&rsquo;s account held with the Bank monthly in arrears, notwithstanding\r\n                    that\r\n                    such balance may have been increased by the debiting of interest to such balance, and is due and\r\n                    payable immediately.</li>\r\n            </ol>\r\n        </li>\r\n        <li>The Bank may, from time to time, upon 10 (ten) business days prior written notice to the Borrower vary\r\n            the\r\n            pricing applicable to the Loan and the method of calculating it during the agreed term of the Loan\r\n            subject to\r\n            changes in CBN regulations and money market conditions. Such changes will be communicated either\r\n            directly to the\r\n            Borrower or via a general notice to all Borrowers of the Bank. If the Bank elects to advise such\r\n            change(s)\r\n            directly to the Borrower, the Bank&rsquo;s advice will take the form of a letter or SMS</li>\r\n    </ol>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>6. Use of EZ Cash </strong></p>\r\n    <p>You can access and use EZ Cash service on Internet Banking, Mobile App, Web or USSD channels to request for\r\n        EZ Cash loans. We will act on instructions that appear to have been sent by you</p>\r\n    <p>Use of a communication system means we do not interact face-to-face. Unless you notify us before we give\r\n        effect to an instruction, you authorize us to rely on and perform all instructions that appear to originate\r\n        from you (even if someone else is impersonating you).</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>7. Your authority</strong></p>\r\n    <p>You permit us to regard all activities you conduct, or instructions sent when you request for EZ Cash as\r\n        being authorized by you and intended to have legal force and effect.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>8. Sufficient notice</strong></p>\r\n    <p>You permit us to issue notices required in terms of these Terms & Conditions, legislation or regulation by\r\n        making such notification available via our communication systems or sending such notification by email, SMS\r\n        or similar future technologies. Any notices so issued by us, will as far as they contain contractual terms\r\n        relating to EZ Cash, also form part of these Terms and Conditions.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>9. Nature of information on the communication system</strong></p>\r\n    <p>Information on the communication system is intended to provide you with only general information about the\r\n        bank, its products, services and objectives. From time to time we may provide information on:</p>\r\n    <p>a. projected revenues, income, earnings per share, capital expenditures, dividends, capital structure or\r\n        other financial items;</p>\r\n    <p>b. our plans, objectives and projections for future operations and service</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>10. Transmission of information and security tips</strong></p>\r\n    <p>Information transmitted via an unsecured link over a communication system is susceptible to potential\r\n        unlawful access, distortion or monitoring. You must comply with the security tips which are published on our\r\n        website from time to time. As we do not have the ability to prevent unlawful activities by unscrupulous\r\n        persons, you accept that we cannot be held liable for any loss, harm or damage suffered by you as a result\r\n        thereof. To limit these risks, we may request independent verification of any information transmitted by you\r\n        via our communication system from time to time.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>11. Indemnity</strong></p>\r\n    <p>You shall indemnify us for all losses and costs we may incur on your behalf due to your non-payment; any\r\n        instruction exceeding the amount available in your bank account; or unauthorised instructions executed which\r\n        were not due to our negligence</p>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>12. Unavailability of EZ Cash Services</strong></p>\r\n    <p>We will at all times and for whatever reason, have the sole and exclusive right to suspend or terminate EZ\r\n        Cash without any prior notification or giving any reasons for such termination or suspension. You\r\n        acknowledge and accept that EZ Cash banking services may be unavailable from time to time for any reason,\r\n        including: technical failure or problems with the communication system itself or our communication system\r\n        underlying banking systems (the bank system); technical failure or problems with any systems directly or\r\n        indirectly underlying EZ Cash transactional services that are owned or controlled by third parties;\r\n        unavailability of telecommunication or electricity services; or other circumstances beyond our control . You\r\n        undertake, in the event of unavailability of EZ Cash services, to limit potential errors/losses by using any\r\n        other means of Banking with us for the duration of the unavailability of EZ Cash banking services.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>13. Warranties and representations</strong></p>\r\n    <p>\r\n        We do not expressly warrant that EZ Cash services will be error-free or will meet any particular criteria of\r\n        accuracy, completeness or reliability of information, performance or quality. We expressly disclaim all\r\n        implied warranties, including, without limitation, warranties of merchantability, title, fitness for a\r\n        particular purpose, non-infringement, compatibility, security and accuracy.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>14. Disclaimer and limitation of liability</strong></p>\r\n    <p>\r\n        For purposes of this clause, the Bank as well as other Stanbic IBTC entities, its affiliates, shareholders,\r\n        employees, consultants and agents. Although taking sufficient care to ensure that the content provided on\r\n        the communication system is accurate and that you suffer no loss or damage as a result of you using the\r\n        content on the communication system and EZ Cash services are provided &#8220;as is&#8221;. We are not liable\r\n        for\r\n        any\r\n        damages whatsoever relating to your use of EZ Cash services on the communication system. This includes the\r\n        information contained on the communication system or your inability to use the communication system or EZ\r\n        Cash services, including, without limitation, any direct, indirect, special, incidental or consequential\r\n        damages, whether arising out of contract, statute, delict or otherwise and regardless of whether we were\r\n        expressly advised of the possibility of such loss or damage. Without derogating from the generality of the\r\n        foregoing, we are not liable for:\r\n    </p>\r\n    <p>a. any damages which you suffer as a result of a compromise of your access codes.</p>\r\n    <p>b. any interruption, malfunction, downtime or other failure of the communication system or EZ Cash service,\r\n        our banking system, third party system, databases or any component part thereof for whatever reason.</p>\r\n    <p>c. any loss or damage which arises from your transactions, instructions, orders, investment decisions,\r\n        purchases or disposal of goods and services, including financial instruments or currencies, from third\r\n        parties based upon the information provided on the communication system.</p>\r\n    <p>d. any loss or damage with regard to your or any other data directly or indirectly caused by malfunction of\r\n        our bank system, third party systems, power failures, unlawful access to or theft of data, computer viruses\r\n        or destructive code on the bank system or third-party systems; programming defects, negligence on our part.\r\n    </p>\r\n    <p>e. any interruption, malfunction, downtime or other failure of goods or services provided by third parties,\r\n        including, without limitation, third party systems such as the public switched telecommunication service\r\n        providers, internet service providers, electricity and water suppliers, local authorities and certification\r\n        authorities</p>\r\n    <p>f. any event over which we have no direct control.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>15. Breach</strong></p>\r\n    <p>We may terminate your access to EZ Cash services if you breach a material term of these terms and conditions\r\n        and fail to remedy it within five days of you being notified by us. We may do this without detracting from\r\n        our right to take any other steps available to us at law or under these Terms & Conditions. If you have\r\n        consistently breached any of these Terms and Conditions including where; you are, or we reasonably suspect\r\n        you may be, using or obtaining, or allowing someone else to use an account or receive services or money\r\n        illegally; or your account is, or we reasonably suspect your account is, being used for an illegal or\r\n        fraudulent purpose; or we have reasonable grounds to suspect fraudulent use of your security details; or we\r\n        have reasonable grounds for believing you have committed or are about to commit a crime in connection with\r\n        your account; or you have not satisfied any anti-money laundering requirements or there has been or we\r\n        suspect there has been fraud involving any of your accounts with us; or If there has been or we suspect\r\n        there has been suspicious activity on your account; or If you stop holding any account, product or service\r\n        in respect of which the EZ Cash Services may be used.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>16. Capacity to enter into these Terms & Conditions</strong></p>\r\n    <p>You warrant to us that you have the required legal capacity to agree and be bound by these terms and\r\n        conditions. Anyone below the age of 18 must be assisted by their legal guardian when reading this these\r\n        Terms & Conditions. If you are below 18 years of age you have to speak to your legal guardian or parents. If\r\n        you are unsure whether you have the legal capacity to enter into contractual agreements/ these Terms &\r\n        Conditions., please contact our Customer Contact Centre for assistance before you start or continue to use\r\n        EZ Cash Services.</p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>17. Contact details /address for notices </strong></p>\r\n    <p>For the purpose of service of any legal process we choose the following registered address: E-Business\r\n        Department, Stanbic IBTC Bank PLC, IBTC Place, Walter Carrington Crescent, Victoria Island, Lagos.</p>\r\n\r\n    <div style=\"margin-left: 24px;\">\r\n        <p style=\"text-align: justify;\"><strong>For Complaint or Query Management</strong></p>\r\n        <p>Do not hesitate to reach out to your lender through the following</p>\r\n        <p>\r\n            Telephone: +234 1 422 2222<br>\r\n            Address: The IBTC Place, Walter Carrington Crescent, Victoria Island, Lagos<br>\r\n            Email: <span\r\n                style=\"text-decoration: underline;color: blue;\">customercarenigeria@stanbicibtc.com</span><br>\r\n        </p>\r\n    </div>\r\n    <p>If dissatisfied with the resolution of your complaint, you may escalate the complaint to the Consumer\r\n        Protection Department of the Central Bank of Nigeria by writing to the Director, Consumer Protection\r\n        Department, CBN, Abuja or send an email to:<span\r\n            style=\"text-decoration: underline;color: blue;\">cpd@cbn.gov.ng.</span></p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>18. Law that applies to the Terms and Conditions</strong></p>\r\n    <p>The EZ Cash Services Terms and Conditions will be governed and construed in accordance with the Federal\r\n        Republic of Nigeria without reference to any conflict of law provisions, and any dispute arising therefrom\r\n        shall be determined in accordance with such laws. Except stated otherwise, all copyright in the\r\n        communication systems is owned by or licensed to us or members of Stanbic IBTC Group.</p>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>19. General provisions</strong></p>\r\n    <p>No failure or delay by us to exercise any of our rights is to be construed as a waiver of any such right,\r\n        whether this is done expressly or is implied. It will also not affect the validity of any part of these\r\n        conditions or prejudice our right to take subsequent action against you.</p>\r\n\r\n    <p>If any of these terms, conditions or provisions are held to be invalid, unlawful or unenforceable to any\r\n        extent; such term, condition or provision will be severed from the remaining terms, conditions and\r\n        provisions, which will continue to be valid to the full extent permitted by law. </p>\r\n    <p>If you have any questions about this terms and conditions or do not understand anything in these Terms &\r\n        Conditions, please call our Customer Care Centre 0700 909 909 909\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>20. Payments</strong></p>\r\n    <p>1. All payments by the Borrower under the Loan, whether of principal, interest, fees, costs or otherwise,\r\n        shall be made in full in immediately available funds, without set-off or counterclaim and free and clear of\r\n        any deduction or withholding on account of tax or otherwise.</p>\r\n    <p>2. If the Borrower is required by law to make any deduction or withholding from any payment under the Loan,\r\n        the sum due from the Borrower in respect of such payment shall be increased to the extent necessary to\r\n        ensure that, after the making of such deduction or withholding, the Bank receives a net sum equal to the sum\r\n        which it would have received had no such deduction or withholding been required.</p>\r\n    <p>\r\n        3. If a repayment in terms of this Term Loan falls due on a date, which is not a Business day (being a day\r\n        which is a Saturday, Sunday or official public holiday in Nigeria), then such repayment shall be made on the\r\n        due date\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>21. Confidential Information</strong></p>\r\n    <ol>\r\n        <li>\r\n            The Borrower hereby consents that the Bank may: -\r\n            <ol>\r\n                <li>hold and process, by computer or otherwise, any information obtained about the Borrower as a\r\n                    consequence of the Facilities contemplated in this Letter;</li>\r\n                <li>include personal data in the Bank&rsquo;s systems which may be accessed by other companies in\r\n                    the\r\n                    Bank&rsquo;s group for credit assessment, statistical analysis including behavior and scoring\r\n                    and to\r\n                    identify products and services (including those supplied by third parties) which may be relevant\r\n                    to the Borrower; and</li>\r\n                <li>permit other companies within the Bank&rsquo;s group to use personal data and any other\r\n                    information it\r\n                    holds about the Borrower to bring to its attention products and services which may be of\r\n                    interest to the Borrower.</li>\r\n            </ol>\r\n        </li>\r\n        <li>\r\n            The Borrower further consents that the Bank may disclose its personal data and/or information relating\r\n            to the Borrower including data and information relating to this Letter and any documents referred to\r\n            herein or the assets, business or affairs of the Borrower outside the Bank&rsquo;s group whether such\r\n            personal\r\n            data and/or information is obtained after the Borrower ceases to be the Bank&rsquo;s Borrower or during\r\n            the\r\n            continuance of the banker-Borrower relationship or before such relationship was in contemplation:\r\n            <ol>\r\n                <li>for fraud prevention purposes;</li>\r\n                <li>to licensed credit reference agencies or any other creditor, if the Borrower is in breach of\r\n                    this Loan Letter or any documents referred to herein;</li>\r\n                <li>to its external lawyers, auditors and other sub-contractors or persons acting as the\r\n                    Bank&rsquo;s\r\n                    agents;</li>\r\n                <li>to any person who may assume the Bank&rsquo;s rights under this Loan Letter;</li>\r\n                <li>if the Bank has a right or duty to disclose or are permitted or compelled to do so by law; and\r\n                </li>\r\n                <li>for the purpose of exercising any power, remedy, right, authority, or discretion relevant to\r\n                    this Loan Letter or any other document.</li>\r\n            </ol>\r\n        </li>\r\n        <li>\r\n            The Borrower acknowledges and agrees that, notwithstanding the terms of any other agreement between the\r\n            Borrower and the Bank, a disclosure of information by the Bank in the circumstances contemplated by this\r\n            clause does not violate any duty owed to the Borrower either in common law or pursuant to any agreement\r\n            between the Bank and the Borrower or in the ordinary course of banking business and the customs, usage\r\n            and practice related thereto and further that disclosure as aforesaid may be made without reference to\r\n            or further authority from the Borrower and without inquiry by the Bank as to the justification for or\r\n            validity of such disclosure.\r\n        </li>\r\n    </ol>\r\n\r\n\r\n    <p style=\"text-align: justify;\"><strong>22. Cross Default</strong></p>\r\n    <p>Default in respect of any other financial obligation or shall render the Borrower default.\r\n        &lsquo;Default&rsquo; in this\r\n        context shall include, but not be limited to, any irregular conduct of an account, non-compliance with the\r\n        legal and regulatory requirements of Nigeria or violation of its corporate governance principles.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>Environmental & Social Responsibility</strong></p>\r\n\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">23.1</span>\r\n            The Borrower warrants and represents to the Bank that it is in full compliance with all applicable laws,\r\n            regulations and practices relating to the protection of the environment and its social responsibility\r\n            applicable to it in each jurisdiction in which the Borrower conducts business (its &#8220;Environmental &\r\n            Social\r\n            Responsibility&#8221;) and hereby undertake to continue to do so for so long as the Borrower is indebted to\r\n            or\r\n            owes any obligations to the Bank.\r\n        </div>\r\n    </p>\r\n\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">23.2</span>\r\n            The Borrower warrants that it is not aware of any circumstances which may prevent full compliance with\r\n            its Environmental & Social Responsibility in future\r\n        </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">23.3</span>\r\n        The Borrower hereby indemnifies the Bank against any loss, damage, claims, costs or any other\r\n        liability, which may arise (because of this or any other banking facility and/or the Bank having an interest\r\n        in any of the Borrower&rsquo;s assets) in respect of a breach of, or a failure by the Borrower to meet its\r\n        Environmental & Social Responsibilities.\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">23.3</span>\r\n            The Borrower undertakes to notify the Bank in the event of material Environmental & Social incidents\r\n            which include contamination, strikes, protests, lawsuits, claims or media coverage of Environmental & Social\r\n            concerns, or suspension or withdrawal of E&S permits.\r\n        </div>\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>24. Sanctions</strong></p>\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">24.1</span>\r\n            The Borrower/Customer declares warrants, represents and undertakes to the Bank on the\r\n            date of signature hereof and on each date upon which a facility is utilized that:\r\n        </div>\r\n    </p>\r\n    <p>\r\n        <div style=\"display: flex;\">\r\n            <span style=\"min-width: 70px;\">24.1.1</span>\r\n            He/She/it will not use or make available the proceeds of any of the Facilities for the\r\n            purposes of\r\n            financing, directly or indirectly, the activities, business or transactions of any entity or person or\r\n            subsidiary or affiliate which is Sanctioned or in a country which is subject to any Sanctions\r\n        </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.1.2</span>\r\n        He/She/it will not contribute or otherwise make available, directly or indirectly, the proceeds of\r\n        any of the Facilities to any other entity, person, affiliate or subsidiary, or if such party uses or intends\r\n        to use such proceeds for the purpose of financing the activities of any person or entity which is subject to\r\n        any Sanctions;\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.1.3</span>\r\n        He/She/it is not involved in any illegal or terrorist activities; and\r\n    </div>\r\n    </p>\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.1.4</span>\r\n        none of its bank accounts held with the Bank are being used fraudulently, negligently, for illegal or\r\n        terrorist activities, or for any purpose that does not comply with any law.\r\n    </div>\r\n    </p>\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.2</span>\r\n        The Borrower/Customer hereby indemnifies and holds the Bank and/or any Bank Related Entity (Bank\r\n        Related Entity shall mean Standard Bank Group Limited or any other Subsidiary or associate company of\r\n        Standard Bank Group Limited) harmless against any actions, proceedings, claims and/or demands that may be\r\n        brought against the Bank and/or Bank Related Entity and all losses, damages, costs and expenses which the\r\n        Bank and/or Bank Related Entity may incur or sustain, in connection with or arising out of\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.2.1</span>\r\n        the seizure, blocking or withholding of any funds by any Sanctioning Body; and\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.2.2</span>\r\n        the breach of any warranties as set out in paragraphs above.\r\n        Payment under the above indemnity shall be made by the Borrower/Customer on demand by the Bank or such other\r\n        Bank Related Entity\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3</span>\r\n        Definitions\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.1</span>\r\n        &#8220;Sanction List&#8221; shall mean the Specially Designated Nationals and Blocked Persons List of OFAC\r\n        and/or\r\n        the UNSC list of persons or entities suspected to be involved in terrorist related activities or the funding\r\n        thereof and/or any other list of HMT and/or EU\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.2</span>\r\n        &#8220;Sanctioned&#8221; shall mean listed on all or any one of the Sanction Lists and/or subject to any\r\n        Sanctions.\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3</span>\r\n        &#8220;Sanctions&#8221; shall mean the economic sanctions, laws, regulations, embargoes or restrictive\r\n        measures\r\n        administered, enacted or enforced by any one of the following regimes (each a &#8220;Sanctioning\r\n        Body&#8221;):the\r\n        United\r\n        States Government;\r\n    </div>\r\n    </p>\r\n\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.1</span>\r\n        the United Nations;\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.2</span>\r\n        the European Union;\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.3</span>\r\n        the United Kingdom; or\r\n    </div>\r\n    </p>\r\n\r\n    <p>\r\n    <div style=\"display: flex;\">\r\n        <span style=\"min-width: 70px;\">24.3.3.4</span>\r\n        the respective governmental institutions and agencies of any of the foregoing, including without\r\n        limitation, the Office of Foreign Assets Control of the Department of Treasury of the United States of\r\n        America (&#8220;OFAC&#8221;) or the United Nations Security Council (&#8220;UNSC&#8221;) or Her\r\n        Majesty&rsquo;s Treasury\r\n        of the\r\n        United\r\n        Kingdom (&#8220;HMT&#8221;) or the European Union&rsquo;s Common Foreign and Security Policy\r\n        (&#8220;EU&#8221;).\r\n    </div>\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>25. MLPA, AML/CFT Requirements </strong></p>\r\n    <p>\r\n        The Borrower acknowledges that the Bank is obliged to comply with the Money Laundering (Prohibition) Act\r\n        (MLPA) 2011 (as amended) and Central Bank of Nigeria Anti-Money Laundering/Combating of Financing of\r\n        Terrorism (AML/CFT) Regulation, 2009 (as amended), and undertakes to provide such information and documents\r\n        as the Bank may, from time to time request in order to comply with such MLPA and AML/CFT requirements\r\n        including information and documents of the Borrower from time to time.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>26. Global Standing Instruction</strong></p>\r\n    <p>\r\n        By accepting this loan offer and by drawing on the loan, I covenant to repay the loan as and when due. In\r\n        the event that I fail to repay the loan as agreed, and the loan becomes delinquent, the bank shall have the\r\n        right to report the delinquent loan to CBN through the Credit Risk Management System (CRMS) or by any other\r\n        means, and request the CBN to exercise its regulatory power to direct all banks and other financial\r\n        institutions under its regulatory purview to set-off my indebtedness from any money standing to my credit in\r\n        any bank account and from any other financial assets they may be holding for my benefit.\r\n    </p>\r\n    <p>\r\n        I covenant and warrant that the CBN shall have power to set-off my indebtedness under this loan agreement\r\n        from all such monies and funds standing to my credit/benefit in any and all such accounts or from any other\r\n        financial assets belonging to me and in the custody of any such bank.\r\n    </p>\r\n    <p>\r\n        I hereby waive any right of confidentiality whether arising under common law or statute or in any other\r\n        manner whatsoever and irrevocably agree that I shall not argue to the contrary before any court of law,\r\n        tribunal, administrative authority or any other body acting in any judicial or quasi-judicial capacity.\r\n    </p>\r\n\r\n    <p style=\"text-align: justify;\"><strong>27. Credit Guarantee (for Business Customers only)</strong></p>\r\n    <p>\r\n        I / We hereby consent and authorize the Bank to guarantee the credit facilities with any of the licenced Credit Guarantee Companies in Nigeria  and hereby confirm that I / We have sought and obtained independent professional advise and hence do not have any objections to the Bank guaranteeing my / our credit facilities with the Credit Guarantee Companies in Nigeria.\r\n    </p>\r\n</div>"
  }
};
