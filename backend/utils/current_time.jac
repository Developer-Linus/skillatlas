import from datetime { datetime }
def get_current_time() {
    return datetime.utcnow().isoformat();
}
