use std::io::Write;
use termcolor::{BufferWriter, Color, ColorChoice, ColorSpec, WriteColor};

fn main() {
  let bufwtr = BufferWriter::stderr(ColorChoice::Always);
  let mut buffer = bufwtr.buffer();
  neovim_logo(&mut buffer);

  let _ = bufwtr.print(&buffer);
}

#[inline]
pub fn buf_clean(buf: &mut termcolor::Buffer) {
  let _ = buf.reset();
  buf.clear();
}

fn neovim_logo(buf: &mut termcolor::Buffer) {
  let nv_blue = Some(Color::Rgb(20, 120, 180));
  let nv_green = Some(Color::Rgb(88, 148, 59));
  buf_clean(buf);

  // Line 1
  // --------------------------------------------------------------
  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    " ██     ██"
  );

  // Line 2
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
  );

  let _ = write!(buf,
    ""
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
    .set_bg(nv_green)
  );

  let _ = write!(buf,
    ""
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "███    ███"
  );

  // Line 3
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
    .set_bg(nv_green)
  );

  let _ = write!(buf,
    "██"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "███   ████"
  );

  // Line 4
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
    .set_bg(nv_green)
  );

  let _ = write!(buf,
    "███"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "███  ████"
  );

  // Line 5
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
  );

  let _ = write!(buf,
    "████"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "███ ████"
  );

  // Line 6
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
  );

  let _ = write!(buf,
    "████"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    " ███████"
  );

  // Line 7
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
  );

  let _ = write!(buf,
    "████"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "  ███████"
  );

  // Line 8
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
  );

  let _ = write!(buf,
    "████"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "   ██████"
  );

  // Line 9
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
  );

  let _ = write!(buf,
    "███"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "    ████"
  );

  // Line 10
  // --------------------------------------------------------------

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_blue)
  );

  let _ = write!(buf,
    " ██"
  );

  let _ = buf.set_color(ColorSpec::new()
    .set_fg(nv_green)
  );

  let _ = writeln!(buf,
    "     ██"
  );
}
