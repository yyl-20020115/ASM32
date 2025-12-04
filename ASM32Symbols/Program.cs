namespace ASM32Symbols;

internal class Program
{
    static void Main(string[] args)
    {
        List<string> lines = [];
        using var reader = new StreamReader("ASM244.ASM");
        using var writer = new StreamWriter("ASM244D.ASM");
        string? line;
        while (null != (line = reader.ReadLine()))
        {
            var si = line.IndexOf("DM");
            if (si >= 0 && char.IsWhiteSpace(line[si + 2]))
            {
                var pre = $"{line[..si]}DB{line[si + 2]}";
                var data = line[(si + 2)..];
                List<string> parts = [];
                var builder = new System.Text.StringBuilder();
                var quoting = false;
                for (int p = data.Length - 1; p >= 0; p--)
                {
                    var c = data[p];
                    if (p > 0 && data[p - 1] != '\\' || p == 0)
                    {
                        if (c == '\'' || c == '"')
                            quoting = !quoting;
                    }
                    if (!quoting && (c == ',' || char.IsWhiteSpace(c)))
                    {
                        var val = builder.ToString();
                        if(val!="\"\"" && val!="''")
                            parts.Add(val);
                        if (p == 0) break;
                        builder.Clear();
                        continue;
                    }
                    builder.Insert(0, c);
                }
                parts.Reverse();
                List<string> newParts = [];
                foreach (var part in parts)
                {
                    if (part.Length >= 3 && (part[0] == '\'' && part[^1] == '\'' || part[0] == '"' && part[^1] == '"'))
                    {
                        var quote = part[0];
                        var last = part[^2];
                        var before = part[..^2];
                        var result = before.Length>1
                            ? $"{before}{quote}, '{last}'+ 080H"
                            : $"'{last}' + 080H";
                        newParts.Add(result);
                    }
                    else if (!string.IsNullOrEmpty(part))
                    {
                        newParts.Add(part);
                    }
                }
                line = pre + string.Join(", ", newParts);
            }
            writer.WriteLine(line);
        }
    }
}
