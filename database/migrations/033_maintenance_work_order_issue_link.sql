CREATE TABLE maintenance_work_order_issue_links (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 work_order_id BIGINT UNSIGNED NOT NULL,
 issue_id INT UNSIGNED NOT NULL,
 created_by INT UNSIGNED NOT NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_mwo_issue(work_order_id,issue_id),
 CONSTRAINT fk_mwo_issue_wo FOREIGN KEY(work_order_id) REFERENCES maintenance_work_orders(id),
 CONSTRAINT fk_mwo_issue_issue FOREIGN KEY(issue_id) REFERENCES inv_issues(id),
 CONSTRAINT fk_mwo_issue_actor FOREIGN KEY(created_by) REFERENCES users(id)
) ENGINE=InnoDB;
