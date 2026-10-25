<?php
declare(strict_types=1);
namespace Hls\Services;
use Hls\Config;
final class Migrator
{
    public static function install(\PDO $db, string $database): bool
    {
        Config::databaseName($database);
        if ($db->query('SELECT DATABASE()')->fetchColumn() !== $database) throw new \RuntimeException('Koneksi database berbeda dari target.');
        $tables = $db->query('SHOW TABLES')->fetchAll(\PDO::FETCH_COLUMN);
        $changed=false;
        if ($tables) {
            if (!(in_array('schema_migrations', $tables, true) && $db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='001_foundation'")->fetchColumn())) {
            throw new \RuntimeException('Database tidak kosong tanpa migration lengkap. Periksa instalasi parsial secara manual.');
            }
        } else {
            self::sql($db,'001_foundation'); $changed=true;
        }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='002_master_data'")->fetchColumn()) {
            self::sql($db,'002_master_data');
            \Hls\Database::transaction($db,static function()use($db):void{
                MasterPermissions::seed(new \Hls\Repositories\Repository($db),require dirname(__DIR__,2).'/app/master-data.php');
                $db->exec("INSERT INTO schema_migrations(version) VALUES ('002_master_data')");
            }); $changed=true;
        }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='003_trucking'")->fetchColumn()) {
            self::sql($db,'003_trucking');
            \Hls\Database::transaction($db,static function()use($db):void{
                ExpeditionPermissions::seed(new \Hls\Repositories\Repository($db));
                $db->exec("INSERT INTO schema_migrations(version) VALUES ('003_trucking')");
            }); $changed=true;
        }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='004_trucking_operations'")->fetchColumn()) {
            self::sql($db,'004_trucking_operations');
            \Hls\Database::transaction($db,static function()use($db):void{
                ExpeditionPermissions::operations(new \Hls\Repositories\Repository($db));
                $db->exec("INSERT INTO schema_migrations(version) VALUES ('004_trucking_operations')");
            }); $changed=true;
        }
        $equipmentChanged = EquipmentMigration::install($db, $database);
        $financeChanged = false;
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='006_finance_foundation'")->fetchColumn()) {
            self::sql($db,'006_finance_foundation');
            $db->exec("INSERT INTO schema_migrations(version) VALUES ('006_finance_foundation')");
            $financeChanged = true;
        }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='007_finance_permissions'")->fetchColumn()) {
            self::sql($db,'007_finance_permissions');
            $db->exec("INSERT INTO schema_migrations(version) VALUES ('007_finance_permissions')");
            $financeChanged = true;
        }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='008_finance_invoice_permissions'")->fetchColumn()) { self::sql($db,'008_finance_invoice_permissions'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('008_finance_invoice_permissions')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='009_finance_receivables_permissions'")->fetchColumn()) { self::sql($db,'009_finance_receivables_permissions'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('009_finance_receivables_permissions')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='010_finance_invoice_edit_permission'")->fetchColumn()) { self::sql($db,'010_finance_invoice_edit_permission'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('010_finance_invoice_edit_permission')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='011_finance_owner_read_permissions'")->fetchColumn()) { self::sql($db,'011_finance_owner_read_permissions'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('011_finance_owner_read_permissions')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='012_finance_payment_view_permission'")->fetchColumn()) { self::sql($db,'012_finance_payment_view_permission'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('012_finance_payment_view_permission')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='013_finance_payment_reverse_permission'")->fetchColumn()) { self::sql($db,'013_finance_payment_reverse_permission'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('013_finance_payment_reverse_permission')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='014_finance_expense_permissions'")->fetchColumn()) { self::sql($db,'014_finance_expense_permissions'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('014_finance_expense_permissions')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='015_fin_supplier_payments'")->fetchColumn()) { self::sql($db,'015_fin_supplier_payments'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('015_fin_supplier_payments')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='016_finance_payable_permissions'")->fetchColumn()) { self::sql($db,'016_finance_payable_permissions'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('016_finance_payable_permissions')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='017_finance_payable_action_permissions'")->fetchColumn()) { self::sql($db,'017_finance_payable_action_permissions'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('017_finance_payable_action_permissions')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='018_fin_supplier_bill_posted'")->fetchColumn()) { self::sql($db,'018_fin_supplier_bill_posted'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('018_fin_supplier_bill_posted')"); $financeChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='019_inventory_stock_ledger'")->fetchColumn()) { self::sql($db,'019_inventory_stock_ledger'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('019_inventory_stock_ledger')"); }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='020_inventory_receipts'")->fetchColumn()) { self::sql($db,'020_inventory_receipts'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('020_inventory_receipts')"); }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='021_inventory_issues'")->fetchColumn()) { self::sql($db,'021_inventory_issues'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('021_inventory_issues')"); }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='022_inventory_multi_warehouse'")->fetchColumn()) { self::sql($db,'022_inventory_multi_warehouse'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('022_inventory_multi_warehouse')"); }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='023_inventory_warehouse_permissions'")->fetchColumn()) { self::sql($db,'023_inventory_warehouse_permissions'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('023_inventory_warehouse_permissions')"); }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='029_inventory_reservations'")->fetchColumn()) { self::sql($db,'029_inventory_reservations'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('029_inventory_reservations')"); }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='030_equipment_p2h'")->fetchColumn()) { self::sql($db,'030_equipment_p2h'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('030_equipment_p2h')"); $equipmentChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='031_equipment_unit_holds'")->fetchColumn()) { self::sql($db,'031_equipment_unit_holds'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('031_equipment_unit_holds')"); $equipmentChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='032_maintenance_work_orders'")->fetchColumn()) { self::sql($db,'032_maintenance_work_orders'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('032_maintenance_work_orders')"); $equipmentChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='033_maintenance_work_order_issue_link'")->fetchColumn()) { self::sql($db,'033_maintenance_work_order_issue_link'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('033_maintenance_work_order_issue_link')"); $equipmentChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='034_maintenance_preventive'")->fetchColumn()) { self::sql($db,'034_maintenance_preventive'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('034_maintenance_preventive')"); $equipmentChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='035_maintenance_pm_cycle'")->fetchColumn()) { self::sql($db,'035_maintenance_pm_cycle'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('035_maintenance_pm_cycle')"); $equipmentChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='036_maintenance_cost_foundation'")->fetchColumn()) { self::sql($db,'036_maintenance_cost_foundation'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('036_maintenance_cost_foundation')"); $equipmentChanged=true; }
        if (!$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='037_maintenance_cost_workflow'")->fetchColumn()) { self::sql($db,'037_maintenance_cost_workflow'); $db->exec("INSERT INTO schema_migrations(version) VALUES ('037_maintenance_cost_workflow')"); $equipmentChanged=true; }
        // Model B is opt-in until the existing manifest rows have been audited and backfilled.
        // Set HLS_APPLY_MODEL_B_MIGRATION=1 only in an approved, backed-up environment.
        if (getenv('HLS_APPLY_MODEL_B_MIGRATION') === '1' && !$db->query("SELECT COUNT(*) FROM schema_migrations WHERE version='038_trucking_model_b_allocations'")->fetchColumn()) {
            self::sql($db,'038_trucking_model_b_allocations');
            $db->exec("INSERT INTO schema_migrations(version) VALUES ('038_trucking_model_b_allocations')");
            $changed=true;
        }
        return $changed || $equipmentChanged || $financeChanged;
    }
    private static function sql(\PDO $db,string $version):void
    {
        $sql=file_get_contents(dirname(__DIR__,2).'/database/migrations/'.$version.'.sql');
        foreach(explode(';',$sql) as $statement)if(trim($statement)!=='')$db->exec($statement);
    }
}










