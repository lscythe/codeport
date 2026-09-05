pub fn next_page(link_header: &Option<String>) -> Option<u32> {
    let header = link_header.as_deref()?;
    for part in header.split(',') {
        let mut segments = part.trim().split(';');
        let url = segments.next()?.trim();
        let rel = segments.next().unwrap_or("").trim();
        if rel != r#"rel="next""# {
            continue;
        }
        let url = url.trim_start_matches('<').trim_end_matches('>');
        let query = url.split('?').nth(1)?;
        for pair in query.split('&') {
            let mut kv = pair.split('=');
            if kv.next()? == "page" {
                return kv.next()?.parse().ok();
            }
        }
    }
    None
}
