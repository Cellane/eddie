defmodule Eddie.DeepL.Language do
  def list_names do
    supported() |> Enum.map(& &1.name) |> Enum.sort()
  end

  def list_popular do
    supported()
    |> Enum.filter(fn language -> language.code in popular_codes() end)
    |> Enum.sort(fn first, second -> first.name < second.name end)
  end

  def name_to_code(name) do
    case supported()
         |> Enum.find(fn language ->
           String.downcase(language.name) == String.downcase(name)
         end) do
      nil -> :error
      language -> {:ok, language.code}
    end
  end

  defp popular_codes do
    ["CS", "EN-US", "JA", "ZH", "ES", "RU", "FR", "GE", "IT", "PL", "RO"]
  end

  defp supported do
    [
      %{code: "BG", name: "Bulgarian"},
      %{code: "CS", name: "Czech"},
      %{code: "DA", name: "Danish"},
      %{code: "DE", name: "German"},
      %{code: "EL", name: "Greek"},
      %{code: "EN-GB", name: "English (British)"},
      %{code: "EN-US", name: "English"},
      %{code: "ES", name: "Spanish"},
      %{code: "ET", name: "Estonian"},
      %{code: "FI", name: "Finnish"},
      %{code: "FR", name: "French"},
      %{code: "HU", name: "Hungarian"},
      %{code: "IT", name: "Italian"},
      %{code: "JA", name: "Japanese"},
      %{code: "LT", name: "Lithuanian"},
      %{code: "LV", name: "Latvian"},
      %{code: "NL", name: "Dutch"},
      %{code: "PL", name: "Polish"},
      %{code: "PT-PT", name: "Portuguese"},
      %{code: "PT-BR", name: "Portuguese (Brazilian)"},
      %{code: "RO", name: "Romanian"},
      %{code: "RU", name: "Russian"},
      %{code: "SK", name: "Slovak"},
      %{code: "SL", name: "Slovenian"},
      %{code: "SV", name: "Swedish"},
      %{code: "ZH", name: "Chinese"}
    ]
  end
end
