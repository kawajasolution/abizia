# HLS V2 Operational Document Master

Status dokumen ditentukan dari route, controller, view, schema, permission, dan audit yang tersedia.

| Domain | Dokumen | Status | Pemilik | Ketergantungan |
|---|---|---|---|---|
| Trucking | DO, DN, Manifest, Surat Jalan, Transit, Penerimaan, Klaim, Tracking | PARTIAL | Trucking | Master customer, unit, cabang |
| Trucking | POD/e-POD, Trip Sheet, Uang Jalan, Fuel Usage, Incident Report | NOT IMPLEMENTED | Trucking | Workflow dispatch dan approval |
| Equipment | Kontrak, BAST, Timesheet, Verifikasi Timesheet | PARTIAL | Equipment | Unit, customer, kontrak |
| Equipment | Digital BAST, HM Billing, Breakdown, Downtime, Rental Billing | NOT IMPLEMENTED | Equipment | Timesheet approval, evidence |
| Inventory | Goods Receipt, Goods Issue, Transfer, Reservation, Opname, Adjustment, Stock Card, Report | PARTIAL | Inventory | Item, gudang, ledger |
| Inventory | Material Request, PR, PO, Goods Return, Valuation | NOT IMPLEMENTED | Procurement | Supplier, valuation policy |
| Finance | Invoice, Payment, Receivable, Supplier Bill, Payable Payment, Expense, Cash Ledger, Profit/Loss | PARTIAL | Finance | Customer, supplier, ledger |
| Finance | Quotation, Credit Note, Debit Note, Voucher formal | NOT IMPLEMENTED | Finance | Approval dan accounting policy |
| Maintenance | P2H, Work Order, Spare Part Issue, Service Report, Repair History | NOT IMPLEMENTED | Maintenance | Unit, inventory reservation, approval |

Dokumen yang memiliki kebutuhan cetak/PDF, tanda tangan, atau bukti hukum tetap NEEDS VERIFICATION sebelum dinyatakan siap produksi.
