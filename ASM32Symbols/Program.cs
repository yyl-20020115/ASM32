namespace ASM32Symbols;

internal class Program
{
    static void Main(string[] args)
    {
        List<string> lines = [];
        List<string> labels = [];
        using (var reader = new StreamReader("ASM32.ASM"))
        {
            string? line;
            while (null != (line = reader.ReadLine()))
            {
                lines.Add(line);
                var i = line.IndexOf(':');
                if (i >= 0)
                {
                    var label = line[..i].Trim();
                    if (label.All(c => char.IsAsciiLetterOrDigit(c)||c=='_'))
                    {
                        labels.Add(label);
                    }
                }
            }
        }
        using (var writer = new StreamWriter("ASM32-G.ASM"))
        {
            foreach(var label in labels)
            {
                writer.WriteLine($"GLOBAL {label}");
            }
            foreach(var line in lines)
            {
                writer.WriteLine(line);
            }
        }
    }
}
